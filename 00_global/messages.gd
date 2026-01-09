# MessageBus
extends Node


@warning_ignore("unused_signal")
signal player_interacted( player : Player )

@warning_ignore("unused_signal")
signal player_healed( amount : float )

@warning_ignore("unused_signal")
signal player_health_changed( hp : float, max_hp : float )

@warning_ignore("unused_signal")
signal input_hint_changed( hint : String )

@warning_ignore("unused_signal")
signal back_to_title_screen
