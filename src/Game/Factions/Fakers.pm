package Game::Factions::Fakers;

use strict;
use Readonly;

Readonly our $fakers => {
    C => 15, W => 3, P1 => 5, P2 => 7, P => 1,
    FIRE => 1, AIR => 1, color => 'yellow',
    display => "Fakers",
    ship => { 
        level => 0, max_level => 0,
    },
    teleport => {
        level => 0, max_level => 1,
        type => 'carpet',
        cost => [ { P => 1 }, { P => 1 } ],
        gain => [ { VP => 4 }, { VP => 4 } ],
        advance_gain => [ { carpet_range => 1 } ],
    },
    carpet_range => 1,
    carpet_max_range => 4,
    dig => {
        level => 0, max_level => 2,
        cost => [ { W => 3 }, { W => 2 }, { W => 1} ],
        advance_cost => { W => 2, C => 5, P => 1 },
        advance_gain => [ { VP => 6 } ],
    },
    buildings => {
        D => { advance_cost => { W => 1, C => 2 },
               income => { W => [ 1, 2, 3, 4, 5, 6, 7, 8, 8 ] } },
        TP => { advance_cost => { W => 2, C => 3 },
                income => { C => [ 0, 2, 4, 6, 8 ],
                            PW => [ 0, 1, 2, 4, 6 ] } },
        TE => { advance_cost => { W => 2, C => 5 },
                income => { P => [ 0, 1, 2, 3 ] } },
        SH => { advance_cost => { W => 4, C => 8 },
                advance_gain => [ { GAIN_TELEPORT => 1 } ],
                income => { P => [ 0, 1 ] } },
        SA => { advance_cost => { W => 4, C => 6 },
                income => { P => [ 0, 1 ] } },
    }
};
