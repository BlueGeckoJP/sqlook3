///|
#borrow(out_len)
extern "c" fn utf16le_to_utf8(
  input : Bytes,
  input_len : Int,
  out_len : Int,
) -> Byte = "utf16le_to_utf8"

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
    result.push(stmt.column_blob_as_string(index=0))
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
  let table_names = utf16le_to_utf8(
    get_all_table_names(conn) catch {
      err => {
        println("An error occurred while getting table names: \{err}")
        return
      }
    },
  )
  println(table_names)
  conn.close() catch {
    err => {
      println("An error occurred while closing the database: \{err}")
      return
    }
  }
}
