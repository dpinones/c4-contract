use c4_stark::contract::storage::{Game, Turn};

#[starknet::interface]
trait IFourConnectOnline<T> {
    #[external]
    fn create_game(ref self: T);
    #[external]
    fn join_game(ref self: T, game_id: u128);
    #[external]
    fn finish_game(ref self: T, game_id: u128);
    // fn finish_game(ref self: T, game_id: u128, turns: Array<Turn>);
    #[view]
    fn get_game(self: @T, game_id: u128) -> Game;
}

#[starknet::contract]
mod FourConnectOnline {
    use traits::Into;
    use starknet::{
        ContractAddress, ClassHash, get_caller_address, get_contract_address, replace_class_syscall
    };
    use c4_stark::contract::storage::{Game, Turn};
    use c4_stark::game::solver::{Solver, SolverTrait};

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        _token: ContractAddress,
        _count_games: u128,
        _games: LegacyMap<u128, Game>,
        _balances: LegacyMap<ContractAddress, u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Finish: Finish,
    }

    #[derive(Drop, starknet::Event)]
    struct Finish {
        winner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, token: ContractAddress) {
        self._owner.write(get_caller_address());
        self._token.write(token);
        self._count_games.write(0);
    }

    #[external(v0)]
    impl FourConnectOnline of super::IFourConnectOnline<ContractState> {
        fn create_game(ref self: ContractState) {

            let player_address = get_caller_address();
            self._games.write(
                self._count_games.read(),
                Game {
                    winner: starknet::contract_address_const::<0>(),
                    player_1: player_address,
                    player_2: starknet::contract_address_const::<0>(),
                }
            );

            self._count_games.write(self._count_games.read() + 1);
        }

        fn join_game(ref self: ContractState, game_id: u128) {
            
            let game = self._games.read(game_id);
            let player_address = get_caller_address();
            self._games.write(
                game_id,
                Game {
                    winner: starknet::contract_address_const::<0>(),
                    player_1: game.player_1,
                    player_2: player_address,
                }
            );
        }

        fn finish_game(ref self: ContractState, game_id: u128) {
        // fn finish_game(ref self: ContractState, game_id: u128, turns: Array<Turn>) {
            let mut game = SolverTrait::new();
            let game = self._games.read(game_id);
            let winner = game.player_1;
            // let winner = solver.execute(turns);
            self._games.write(
                self._count_games.read(),
                Game {
                    winner,
                    player_1: game.player_1,
                    player_2: game.player_2,
                }
            );

            self
            .emit(
                Event::Finish(
                    Finish{
                        winner
                    }
                )
            );
        }

        fn get_game(self: @ContractState, game_id: u128) -> Game {
            self._games.read(game_id)
        }
    }
}