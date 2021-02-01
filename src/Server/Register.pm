use strict;

package Server::Register;

use Moose;
use Server::Server;
use Method::Signatures::Simple;

extends 'Server::Server';

use Crypt::Eksblowfish::Bcrypt qw(bcrypt en_base64);
use Net::SMTP;

use Email::Sender::Simple ('sendmail');
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::Simple::Creator;

use Bytes::Random::Secure qw(random_bytes);
use DB::Connection;
use DB::Secret;
use DB::Validation;
use Server::Session;
use Util::CryptUtil;
use Util::PasswordQuality;
use Util::SiteConfig;

has 'mode' => (is => 'ro', required => 1);

method handle($q, $suffix) {
    $self->no_cache();
    my $dbh = get_db_connection;
    my $mode = $self->mode();

    if ($mode eq 'validate') {
        $self->validate_registration($q, $dbh, $suffix);
    } elsif ($mode eq 'request') {
        $self->request_registration($q, $dbh);
    } else {
        die "Unknown mode $mode";
    }
}

method request_registration($q, $dbh) {
    my @error = ();
    
    my $username = $q->param('username');
    my $email = $q->param('email');
    my $password = $q->param('password1');

    if ($username =~ /([^A-Za-z0-9._-])/) {
        push @error, "Invalid character in username '$1'"
    }

    if (!@error) {
        my ($username_in_use) = $dbh->selectrow_array("select count(*) from player where lower(username) = lower(?)", {}, $username);
        my ($email_in_use) = $dbh->selectrow_array("select count(*) from email where lower(address) = lower(?)", {}, $email);

        if ($username_in_use) {
            push @error, "The username is already in use";
        }
        
        if ($email_in_use) {
            push @error, "The email address is already registered";
        }
    }

    if (!@error) {
        my ($reason) = password_too_weak $username, $password;
        if ($reason) {
            push @error, "Bad password: $reason\n";
        }
    }
    
    
    if (!@error) {
        my $data = {
            username => $username,
            email => $email,
            hashed_password => $password
        };
	
        my $token = insert_to_validate $dbh, $data;
        my $url = sprintf "http://$config{domain}/app/register/validate/%s", $token;

	    my $transport = Email::Sender::Transport::SMTP->new({
            host => 'smtp.gmail.com',
            port => '587',
            ssl => 'starttls',
            sasl_username => "$config{gmail_account}",
            sasl_password => "$config{gmail_password}",
            debug => 0,
                                    });


	    my $message = "Validate new account for $username: $url. \nPlease note: Password is stored in cleartext.";
	
        my $email = Email::Simple->create(
            header => [
            To => "$email",
            From => "$config{gmail_account}",
            Subject => 'Account activation for Terra Mystica',
            ],
            body => $message,
            );

	    sendmail($email, {transport => $transport});
    }

    $self->output_json({ error => [@error] });
}

method validate_registration($q, $dbh, $suffix) {
    my $token = $suffix // $q->param('token');

    eval {
        my @data = ();
        my $payload = fetch_validate_payload $dbh, $token;
        @data = ($payload->{username}, $payload->{email},
                 $payload->{hashed_password});

        my $already_done = $self->register($dbh, @data);
        if ($already_done) {
            $self->output_html("<h3>Account already exists</h3>");
        } else {
            $self->output_html( "<h3>Account created</h3>");
        }
    }; if ($@) {
        print STDERR "token: $token\n";
        print STDERR $@;
        $self->output_html( "<h3>Validation failed</h3>");
    }
}

method register($dbh, $user, $email, $hashed_password) {
    my ($already_done) = $dbh->selectrow_array("select count(*) from email where lower(address) = lower(?) and player = ?", {}, $email, $user);

    if (!$already_done) {
        $dbh->do('begin');
        $dbh->do('insert into player (username, displayname, password) values (?, ?, ?)', {},
             $user, $user, $hashed_password);
        $dbh->do('insert into email (address, player, validated, is_primary) values (lower(?), ?, ?, true)',
                 {}, $email, $user, 1);
        $dbh->do('commit');
    }

    return $already_done;
}

1;
