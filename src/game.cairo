use array::ArrayTrait;
use dict::Felt252DictTrait;
use traits::{Into, TryInto};
use starknet::ContractAddress;
use traits::Default;
use integer::{U8IntoFelt252, Felt252TryIntoU8};

const ROWS: u8 = 6;
const COLS: u8 = 7;

#[derive(Destruct)]
struct Game {
    board: Felt252Dict<u8>, 
// current_player: Option<Player>,
}

trait GameTrait {
    fn new() -> Game;
    fn drop_disc(ref self: Game, col: u8);
// fn check_winner(ref self: Game) -> Option<Player>;
// TODO: internal ?
// fn has_connected_four(ref self: Game, player: Player, row: u8, col: u8) -> bool;
}

impl GameTraitImpl of GameTrait {
    fn new() -> Game {
        Game { board: Default::default(),  }
    }

    fn drop_disc(ref self: Game, col: u8) {
        assert(col < ROWS, 'INVALID_COLUMN');

        let mut row_index = 0;
        loop {
            if row_index == COLS {
                break;
            }

            let position: felt252 = position_to_felt(row_index, col).into();
            let value = self.board.get(position);
            if value == 0 {
                // TODO: save current player
                self.board.insert(position, 1);
                break;
            }
            row_index += 1;
        };

        assert(row_index < COLS, 'COLUMN_FULL');
    }
}

fn position_to_felt(row: u8, col: u8) -> u8 {
    row * COLS + col
}

fn felt_to_position(pos: u8) -> (u8, u8) {
    let row = pos / COLS;
    let col = pos % COLS;
    (row, col)
}
