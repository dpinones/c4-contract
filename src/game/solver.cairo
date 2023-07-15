use array::ArrayTrait;
use dict::Felt252DictTrait;
use traits::{Default, Into, TryInto};
use integer::{U8IntoFelt252, Felt252TryIntoU8};
use cmp::{min, max};

const ROWS: u8 = 6;
const COLS: u8 = 7;

use debug::PrintTrait;
use c4_stark::game::entities::{Cell, IntoU8CellImpl, IntoCellU8Impl, 
Player, IntoU8PlayerImpl, IntoPlayerU8Impl, PrintPlayer};
use c4_stark::contract::storage::{Turn};

#[derive(Destruct)]
struct Solver {
    board: Felt252Dict<u8>, 
    current_player: Player,
}

trait SolverTrait {
    fn new() -> Solver;
    fn execute(ref self: Solver, turns: Array<Turn>);
}

impl SolverTraitImpl of SolverTrait {
    fn new() -> Solver {
        Solver { 
            board: Default::default(),
            current_player: Player::Player1(()),   
        }
    }

    fn execute(ref self: Solver, turns: Array<Turn>) {
        
    }
}

fn drop_disc(ref self: Solver, col: u8) {
    assert(col < ROWS, 'INVALID_COLUMN');

    let mut row_index = 0;
    loop {
        if row_index == COLS {
            break;
        }

        let position: felt252 = position_to_felt(row_index, col).into();
        let cell = self.board.get(position);
        if cell == Cell::Empty(()).into() {
            
            // self.current_player.print();

            self.board.insert(position, self.current_player.into());
            self.current_player = match self.current_player {
                Player::Player1(()) => Player::Player2(()),
                Player::Player2(()) => Player::Player1(()),
            };
            break;
        }
        row_index += 1;
    };

    assert(row_index < COLS, 'COLUMN_FULL');

    // last movement
    // y -> row_index
    // x -> col
    // if @self.current_player == @Player::Player1(()) {
        check_winner(ref self, col, row_index);
    // }
}

fn check_winner(ref self: Solver, last_move_x: u8, last_move_y: u8) -> Option<Player> {
    if check_horizontal(ref self, last_move_x, last_move_y) {
        // 'END GAME'.print();
        return Option::Some(self.current_player);
    }
    // 'CONTINUE'.print();
    Option::None(())
}

fn check_horizontal(ref self: Solver, row: u8, col: u8) -> bool {
    let mut start_col = max(col, 3) - 3;
    // 'start_col'.print();
    // start_col.print();
    let end_col = min(col + 3, COLS - 1);
    // 'end_col'.print();
    // end_col.print();

    loop {
        if start_col > end_col {
            break false;
        }

        if _check_horizontal(ref self, row, start_col) {
            break true;
        }

        start_col += 1;
    }
}

fn _check_horizontal(ref self: Solver, row: u8, col: u8) -> bool {
    let mut idx = 0;
    loop {
        if idx == 4 {
            break true;
        }

        let c = col + idx;
        if c >= COLS {
            break false;
        }

        let cell = self.board.get(position_to_felt(row, c).into());
        // 'last move'.print();
        // row.print();
        // c.print();
        // cell.print();
        // self.current_player.print();
        // no es el mismo jugador o esta vacio
        if cell == self.current_player.into() || cell == Cell::Empty(()).into() {
            // 'break false'.print();
            break false;
        }
        idx += 1;
        // '---'.print();
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
