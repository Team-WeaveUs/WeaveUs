// dbClient.mjs
import mysql from 'mysql2/promise';

const config = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

let connection;

// 데이터베이스 연결 가져오기
export async function getConnection() {
  if (!connection) {
    connection = await mysql.createConnection(config);
  }
  return connection;
}

// 데이터베이스 연결 종료
export async function closeConnection() {
  if (connection) {
    await connection.end();
    connection = null;
    console.log('Database connection closed.');
  }
}

// 쿼리 실행 함수
export async function executeQuery(query, params = []) {
  const conn = await getConnection();
  try {
    const [results] = await conn.execute(query, params);
    return results;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}
