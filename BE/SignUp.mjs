import bcrypt from 'bcryptjs';
import { closeConnection, executeQuery } from 'dbclient';

export const handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
        statusCode: 200,
        body: {},
    };
  }
    const { id, pw, name, nickname, number, gender, is_owner } = event.body;

    if (!id || !pw || !name || !nickname || !number || !gender || typeof is_owner === 'undefined') {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다. " },
        };
    }
    
    try {
      var ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              account_id = ?`, 
        [id]);
    
      if (ret.length != 0 ) {
        console.error('<Error> SignUp - same id is exist');
        await closeConnection();
        return {
            statusCode: 408,
            body: { message: "아이디 중복을 확인하세요" },
        };
      }

      ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              number = ?`, 
        [number]);
    
      if (ret.length != 0 ) {
        console.error('<Error> SignUp - same number is exist');
        await closeConnection();
        return {
            statusCode: 408,
            body: { message: "전화번호 중복을 확인하세요" },
        };
      }

      const hashed_pw = await bcrypt.hash(pw, 10);

      ret = await executeQuery(
        `INSERT INTO User (account_id, account_pw, name, nickname, number, gender, is_owner) 
	          VALUES (?, ?, ?, ?, ?, ?, ?)`, 
        [id, hashed_pw, name, nickname, number, gender, is_owner]);

      ret = await executeQuery(
        `SELECT id
            FROM User 
            WHERE 
              account_id = ?`, 
        [id]);
        
      if (ret.length != 1 ) {
        console.error('<Error> SignUp - insert is not executed');
        await closeConnection();
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. " },
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
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. " },
      };
    } finally {
      await closeConnection();
    }
};
