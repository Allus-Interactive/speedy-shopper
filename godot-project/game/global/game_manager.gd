extends Node

var daily_earnings: float = 0
var player_money: float = 0

var is_scanner_open: bool = false

var crate_hold_point: Marker3D = null
var delivery_crate: DeliveryCrate = null
var scroll_container: ScrollContainer = null

var notification_ui: NotificationUI = null

var order_id: int = 1
