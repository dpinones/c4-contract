use c4_stark::game::{GameTrait, check_horizontal};
use traits::{TryInto, Into};

use result::{Result, ResultTrait};
use option::{OptionTrait};

#[test]
#[available_gas(3000000)]
fn test_game_new() {
    let game = GameTrait::new();
}

#[test]
#[available_gas(3000000)]
fn test_game_drop_disc() {
    let mut game = GameTrait::new();
    game.drop_disc(0);
}

#[test]
#[available_gas(3000000)]
#[should_panic(expected: ('COLUMN_FULL', ))]
fn test_game_drop_disc_column_full() {
    let mut game = GameTrait::new();
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
    game.drop_disc(0);
}

#[test]
#[available_gas(3000000)]
#[should_panic(expected: ('INVALID_COLUMN', ))]
fn test_game_drop_disc_invalid_column() {
    let mut game = GameTrait::new();
    game.drop_disc(8);
}

#[test]
#[available_gas(3000000)]
fn test_game_check_horizontal() {
    let mut game = GameTrait::new();

    game.drop_disc(3);
    game.drop_disc(5);
    game.drop_disc(2);
    game.drop_disc(5);
    game.drop_disc(1);
    game.drop_disc(5);
    game.drop_disc(0);
}
