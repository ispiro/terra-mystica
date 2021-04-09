package Game::Factions::Neckbeards;

use strict;
use Readonly;

Readonly our $neckbeards => {
    C => 10, W => 3, P1 => 3, P2 => 9,
    EARTH => 1, FIRE => 1, WATER => 1, AIR => 1, color => 'gray',
    display => "Neckbeards",
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
    ACTE => 1,
    buildings => {
        D => { advance_cost => { W => 1, C => 2 },
               income => { W => [ 1, 2, 3, 4, 5, 6, 7, 8, 8 ] } },
        TP => { advance_cost => { W => 2, C => 3 },
                income => { C => [ 0, 2, 4, 6, 8 ],
                            PW => [ 0, 1, 2, 4, 6] } },
        TE => { advance_cost => { W => 1, C => 5 },
                income => { P => [ 0, 1, 1, 2 ],
                            PW => [ 0, 0, 5, 5 ] } },
        SH => { advance_cost => { W => 4, C => 6 },
                income => { PW => [ 0, 2 ] } },
        SA => { advance_cost => { W => 4, C => 6 },
                income => { P => [ 0, 1 ] } },

    }
};
