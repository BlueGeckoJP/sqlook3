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

///|
fn get_args() -> (String, ArrayView[String]) raise Error {
  let args = @env.args()
  if args.length() < 2 {
    fail("Not enough arguments")
  }
  let database_path = args.get(1)
  if database_path == None {
    fail("Database path is required")
  }
  let table_names = args[2:]
  return (database_path.unwrap(), table_names)
}

///|
fn get_all_table_names(conn : @sqlite3.Connection) -> Array[String] raise Error {
  let result : Array[String] = []
  let stmt = conn.prepare("SELECT name FROM sqlite_master WHERE type='table'")
  while stmt.step() {

  }
  stmt.finalize()
  result
}

///|
fn main {
  let (database_path, table_names) = get_args() catch {
    err => {
      println("An error occurred while getting arguments: \{err}")
      print_help()
      return
    }
  }
  let conn = @sqlite3.Connection::open(database_path) catch {
    err => {
      println("An error occurred while opening the database: \{err}")
      return
    }
  }
  println(get_all_table_names(conn) catch { err => [] })
  conn.close() catch {
    err => {
      println("An error occurred while closing the database: \{err}")
      return
    }
  }
}
