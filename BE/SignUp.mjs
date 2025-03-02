import bcrypt from 'bcryptjs';
import { getConnection, closeConnection, executeQuery } from './dbClient.mjs';

export const handler = async (event) => {
    const { id, pw, name, nickname, number, gender, is_owner } = event.body;

    if (!id || !pw || !name || !nickname || !number || !gender || !is_owner) {
        return {
            statusCode: 400,
            body: { message: "요청이 잘못 전달되었습니다." },
        };
    }
    
    try {
      var ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              account_id LIKE ?`, 
        [id]);
    
      if (ret.length != 0 ) {
        console.error('<Error> SignUp - same id is exist');
        await closeConnection();
        return {
            statusCode: 401,
            body: { message: "아이디 중복을 확인하세요" },
        };
      }

      ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              number LIKE ?`, 
        [number]);
    
      if (ret.length != 0 ) {
        console.error('<Error> SignUp - same number is exist');
        await closeConnection();
        return {
            statusCode: 402,
            body: { message: "전화번호 중복을 확인하세요" },
        };
      }

      const hashed_pw = await bcrypt.hash(pw, process.env.HASH_NUM);

      ret = await executeQuery(
        `INSERT INTO User (account_id, account_pw, name, nickname, number, gender, is_owner) 
	          VALUES (?, ?, ?, ?, ?, ?, ?)`, 
        [id, hashed_pw, name, nickname, number, gender, is_owner]);

      ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              account_id LIKE ?`, 
        [id]);
        
      if (ret.length != 1 ) {
        console.error('<Error> SignUp - insert is not executed');
        await closeConnection();
        return {
            statusCode: 403,
            body: { message: "회원가입에 실패했습니다." },
        };
      }

      await closeConnection();

      
      return {
        statusCode: 200,
        body: { message: "회원가입 성공", user_id: ret[0].id },
      };
        
      
    } catch(error) {
      console.error('<Error> SignUp - Query Failed, can\'t select user id,pw etc...  >> ', error);
      await closeConnection();
      return {
            statusCode: 404,
            body: { message: "..." },
      };
    }
};
