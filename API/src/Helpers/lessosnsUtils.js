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



module.exports = {
    getBlocks
    // Otras funciones separadas por comas...
};