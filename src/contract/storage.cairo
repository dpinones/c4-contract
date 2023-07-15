use starknet::{
    ContractAddress, ClassHash, get_caller_address, get_contract_address, replace_class_syscall
};

#[derive(Copy, Drop, storage_access::StorageAccess, Serde)]
struct Game {
    winner: ContractAddress,
    player_1: ContractAddress,
    player_2: ContractAddress,
}

#[derive(Copy, Drop, Serde)]
struct Turn {
    player: ContractAddress,
    col: u8,
}
