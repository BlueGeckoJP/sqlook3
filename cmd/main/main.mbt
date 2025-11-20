///|
fn main {
  let args = @env.args()
  let database_path = args.get(1)
  if database_path == None {
    print_help()
    return
  }
  if args.length() <= 2 {
    print_help()
    return
  }
  let table_names = args[2:]
  let conn = @sqlite3.Connection::open(database_path.unwrap()) catch {
    err => {
      println("An error occurred while opening the database: \{err}")
      print_help()
      return
    }
  }
  conn.close() catch {
    err => {
      println("An error occurred while closing the database: \{err}")
      return
    }
  }
}

///|
fn print_help() -> Unit {
  let args0 = match @env.args().get(0) {
    Some(args0) => args0.split("/").last().unwrap_or("sqlook3")
    None => "sqlook3"
  }
  println("Usage: \{args0} <database_path> <table_names...>")
  println("Example: \{args0} ./my_database.db users orders\n")
  println("database_path: The path to the database file")
  println(
    "table_names: The names of the tables to look at, multiple selections possible",
  )
}
