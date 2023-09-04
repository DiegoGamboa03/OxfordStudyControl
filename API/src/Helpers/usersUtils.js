const conn = require('../Config/DatabaseConfig');

function getStudentCurrentBlock(student_email) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT current_block FROM Students WHERE email = '${student_email}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    const json = JSON.parse(JSON.stringify(results));
                    resolve(json[0].current_block);
                } else {
                    resolve(null);
                }
            }
        });
    });
}


module.exports = {
    getStudentCurrentBlock
    // Otras funciones separadas por comas...
};