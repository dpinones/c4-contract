use array::ArrayTrait;
use dict::Felt252DictTrait;
use traits::{Into, TryInto};
use starknet::ContractAddress;
use traits::Default;
use integer::{U8IntoFelt252, Felt252TryIntoU8};
use cmp::{min, max};

const ROWS: u8 = 6;
const COLS: u8 = 7;

use debug::PrintTrait;

#[derive(Destruct)]
struct Game {
    board: Felt252Dict<u8>, 
    current_player: Player,
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
        Game { 
            board: Default::default(),
            current_player: Player::Player1(()),   
        }
    }

    fn drop_disc(ref self: Game, col: u8) {
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
}

fn check_winner(ref self: Game, last_move_x: u8, last_move_y: u8) -> Option<Player> {
    if check_horizontal(ref self, last_move_x, last_move_y) {
        // 'END GAME'.print();
        return Option::Some(self.current_player);
    }
    // 'CONTINUE'.print();
    Option::None(())
}

fn check_horizontal(ref self: Game, row: u8, col: u8) -> bool {
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

fn _check_horizontal(ref self: Game, row: u8, col: u8) -> bool {
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

#[derive(Copy, Drop, Serde)]
enum Cell {
    Empty: (),
    Player1: (),
    Player2: (),
}

impl IntoU8CellImpl of Into<Cell, u8> {
    fn into(self: Cell) -> u8 {
        match self {
            Cell::Empty(()) => 0,
            Cell::Player1(()) => 1,
            Cell::Player2(()) => 2,
        }
    }
}

impl IntoCellU8Impl of Into<u8, Cell> {
    fn into(self: u8) -> Cell {
        if (self == 0) {
            return Cell::Empty(());
        } else if (self == 1) {
            return Cell::Player1(());
        } else {
            return Cell::Player2(());
        }
    }
}

#[derive(Copy, Drop, Serde, PartialEq)]
enum Player {
    Player1: (),
    Player2: (),
}

impl IntoU8PlayerImpl of Into<Player, u8> {
    fn into(self: Player) -> u8 {
        match self {
            Player::Player1(()) => 1,
            Player::Player2(()) => 2,
        }
    }
}

impl IntoPlayerU8Impl of Into<u8, Player> {
    fn into(self: u8) -> Player {
        if (self == 1) {
            return Player::Player1(());
        }
        return Player::Player2(());
    }
}

impl PrintPlayer of PrintTrait<Player> {
    fn print(self: Player) {
        match self {
            Player::Player1(()) => 1.print(),
            Player::Player2(()) => 2.print(),
        }
    }
}
