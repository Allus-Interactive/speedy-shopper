extends Resource

class_name Customer

@export var title: TITLE
@export var first_name: String
@export var last_name: String
@export var address: String
@export var dob_year: int
@export var dob_month: int
@export var dob_day: int

enum TITLE { MR, MRS, MS, MISS, DR, SIR, LADY }
