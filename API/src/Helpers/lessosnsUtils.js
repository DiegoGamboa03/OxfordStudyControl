const conn = require('../Config/DatabaseConfig');


function getBlocks(level_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT DISTINCT
        b.id
        FROM Blocks b
        JOIN (
            SELECT id
            FROM Blocks
            WHERE LEVEL = '${level_id}'
        ) AS basic_blocks ON b.id = basic_blocks.id
        ORDER BY id, next_block`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                let json = JSON.parse(JSON.stringify(results));
                const transformedArray = json.map(block => parseInt(block.id));
                resolve(transformedArray);
            }
        });
    });
}

function getLessons(block_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT name FROM Lessons WHERE block = '${block_id}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    const json = JSON.parse(JSON.stringify(results));
                    const lessonNames = json.map(item => item.name);
                    resolve(lessonNames);
                } else {
                    resolve([]);
                }
            }
        });
    });
}



module.exports = {
    getBlocks,
    getLessons
    // Otras funciones separadas por comas...
};