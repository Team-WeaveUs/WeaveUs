import { verifyRefreshToken, createAccessToken, createRefreshToken } from './jwt.mjs';

export const handler = async (event) => {
    if (event.httpMethod === 'OPTIONS') {
      return {
          statusCode: 200,
          body: {},
      };
    }
    
    const verifyed = verifyRefreshToken(event);

    if (verifyed.code !== 1) {
        return {
            statusCode: verifyed.status,
            body: { message: verifyed.message },
        };
    }

    try {
        const accessToken = createAccessToken({ user_id: verifyed.payload.user_id });
        const refreshToken = createRefreshToken({ user_id: verifyed.payload.user_id });

        return {
            statusCode: 200,
            body: {
                message: "인증 성공",
                accessToken: accessToken,
                refreshToken: refreshToken,
                user_id: verifyed.payload.user_id,
            },
        };
        
    } catch (error) {
        return {
            statusCode: 500,
            body: {
                message: '토큰 재발행 실패'
            }
        };
    }
};
