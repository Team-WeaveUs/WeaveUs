// bcrypt 라이브러리를 import 구문으로 불러오기
import bcrypt from 'bcryptjs';
import { getConnection, closeConnection, executeQuery } from './dbClient.mjs';
import { createAccessToken, createRefreshToken, verifyRefreshToken } from './jwt.mjs';

export const handler = async (event) => {
    
    // 요청에서 아이디와 비밀번호를 추출
    const { account_id, password, type } = event.body;

    // 사용자 유효성 검증
    if (!account_id || !password) {
        return {
            statusCode: 400,
            body: { message: "아이디와 비밀번호를 입력하세요." },
        };
    }
    
    try {
      const ret = await executeQuery(
        `SELECT id, account_id, account_pw , nickname
            FROM User 
            WHERE 
              account_id LIKE ?`, 
        [account_id]);
        
    
      if (ret.length != 1 ) {
        console.error('<Error> Login - same id is exist');
        await closeConnection();
        return {
            statusCode: 404,
            body: { message: "사용자를 특정할 수 없습니다." },
        };
      }
      
      await closeConnection();
      
      try {
        // 입력된 비밀번호와 저장된 해시된 비밀번호를 비교
        const isMatch = await bcrypt.compare(password, ret[0].account_pw);

        if (isMatch || password === ret[0].account_pw) {
            // 비밀번호가 맞을 경우

            const accessToken = createAccessToken({ userId : ret[0].id });
            const refreshToken = createRefreshToken({ userId : ret[0].id });
            

            return {
                statusCode: 200,
                body: { 
                  message: "인증 성공", 
                  user_id: ret[0].id, 
                  nickname: ret[0].nickname, 
                  accessToken: accessToken,
                  refreshToken: refreshToken
                 },
            };
        } else {
            // 비밀번호가 틀린 경우
            return {
                statusCode: 401,
                body: { message: "비밀번호가 틀렸습니다." },
            };
        }
      } catch (error) {
          console.error('비밀번호 확인 중 오류 발생:', error);
          return {
              statusCode: 500,
              body: { message: "서버 오류", error: error.message },
          };
      }
        
      
    } catch(error) {
      console.error('<Error> Login - Query Failed, can\'t select user id,pw etc...  >> ', error);
      await closeConnection();
      return {
            statusCode: 405,
            body: { message: "사용자를 찾을 수 없습니다." },
      };
    }
};
