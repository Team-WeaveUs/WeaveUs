import { verifyRefreshToken, createAccessToken, createRefreshToken } from './jwt.mjs';

export const handler = async (event) => {
    const verifyed = verifyRefreshToken(event);

    if (verifyed.code !== 1) {
        return {
            statusCode: verifyed.status,
            body: { message: verifyed.message },
        };
    }

    try {
        const accessToken = createAccessToken({ userId: verifyed.payload.userId });
        const refreshToken = createRefreshToken({ userId: verifyed.payload.userId });

        return {
            statusCode: 200,
            body: {
                message: "인증 성공",
                accessToken: accessToken,
                refreshToken: refreshToken,
                user_id: verifyed.payload.userId,
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
