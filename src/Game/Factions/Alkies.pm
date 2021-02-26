package Game::Factions::Alkies;

use strict;
use Readonly;

Readonly our $alkies => {
    C => 15, W => 3, P1 => 3, P2 => 9,
    WATER => 1, FIRE => 1, color => 'black',
    display => "Alkies",
    ship => { 
        level => 0, max_level => 3,
        advance_cost => { C => 4, P => 1 },
        advance_gain => [ { VP => 2 },
                          { VP => 3 },
                          { VP => 4 } ],
    },
    dig => {
        level => 0, max_level => 2,
        cost => [ { W => 3 }, { W => 2 }, { W => 1 } ],
        advance_cost => { W => 2, C => 5, P => 1 },
        advance_gain => [ { VP => 6 },
                          { VP => 6 } ],
    },
    special => {
        SPADE => { PW => 2 },
        enable_if => { SH => 1 },
        mode => 'gain',
    },
    exchange_rates => {
        C => { VP => 2 },
        VP => { C => 1 }
    },
    buildings => {
        D => { advance_cost => { W => 1, C => 2 },
               income => { W => [ 1, 2, 3, 4, 5, 6, 7, 8, 8 ] } },
        TP => { advance_cost => { W => 2, C => 3 },
                income => { C => [ 0, 2, 4, 7, 11 ],
                            PW => [ 0, 1, 2, 3, 4 ] } },
        TE => { advance_cost => { W => 2, C => 5 },
                income => { P => [ 0, 1, 2, 3 ] } },
        SH => { advance_cost => { W => 4, C => 6 },
                advance_gain => [ { PW => 12 } ],
                income => { C => [ 0, 4 ], PW => [ 0, 4 ] } },
        SA => { advance_cost => { W => 4, C => 6 },
                income => { P => [ 0, 1 ] } },
    }
};


