use array::ArrayTrait;
use dict::Felt252DictTrait;
use traits::{Into, TryInto};
use starknet::ContractAddress;
use option::OptionTrait;
use integer::{U8IntoFelt252, Felt252TryIntoU8};
use debug::PrintTrait;

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


