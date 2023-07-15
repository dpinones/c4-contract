struct Game {
    id: u128, 
}

struct Turn {
    x: u128,
    y: u128,
}

#[starknet::interface]
trait IFourConnectAi<T> {
    #[external]
    fn create_game(ref self: T);
    #[external]
    fn finish_game(ref self: T, game_id: u128);
    #[view]
    fn get_game(self: @T, game_id: u128) -> u128;
}

#[starknet::contract]
mod FourConnectAi {
    use traits::Into;

    #[storage]
    struct Storage {
        value: u128, 
    }

    #[constructor]
    fn constructor(ref self: ContractState, value_: u128) {
        self.value.write(value_);
    }

    #[external(v0)]
    impl FourConnectAi of super::IFourConnectAi<ContractState> {
        fn create_game(ref self: ContractState) {}

        fn finish_game(ref self: ContractState, game_id: u128) {}

        fn get_game(self: @ContractState, game_id: u128) -> u128 {
            1
        }
    }
}
