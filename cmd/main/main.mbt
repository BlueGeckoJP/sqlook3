///|
fn main {
  let conn = @sqlite3.Connection::open("example.db") catch {
    err => {
      println("An error occurred while opening the database: \{err}")
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
