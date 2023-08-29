const conn = require('../Config/DatabaseConfig');
/**
 * Retorna la cantidad de preguntas que tenga un examen dado
 * 
 * @param {String} exam_id - id del examen al que quieres chequear el numero de.
 * @returns {int} retorna un integer con la cantidad de preguntas que tiene el examen.
 */
function getNumQuestions(exam_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT num_questions FROM Exams WHERE name = '${exam_id}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results && results.length > 0) {
                    let resultArray = JSON.parse(JSON.stringify(results));
                    let num_questions = resultArray[0].num_questions;
                    resolve(num_questions);
                } else {
                    resolve(0);
                }
            }
        });
    });
}
/**
 * Retorna la cantidad de preguntas que tenga un examen dado
 * 
 * @param {String} exam_id - id del examen al que quieres chequear el numero de.
 * @param {int} num_questions - cantidad de preguntas que quieres que te devuelva.
 * @returns {Array} lista de preguntas.
 */
function getQuestions(exam_id,num_questions) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT question FROM Questions
        WHERE exam_id = '${exam_id}'
        ORDER BY RAND()
        LIMIT ${num_questions}`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let json = JSON.parse(JSON.stringify(results));
                    let resultArray = [];
                    json.forEach(element => {
                        resultArray.push(element.question);
                    });
                    console.log(resultArray);
                    resolve(resultArray);
                } else {
                    resolve([]);
                }
            }
        });
    });
}

function getGeneratedTestsQuestions(exam_id, student_id, date) {
    return new Promise((resolve, reject) => {
        const sql = `
            SELECT question_id, score, question_position, answer_text 
            FROM GeneratedTestQuestions 
            WHERE exam_id = '${exam_id}'
            AND student_id = '${student_id}'
            AND generated_test_date = '${date}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                const json = JSON.parse(JSON.stringify(results));
                resolve(json);
            }
        });
    });
}

function getQuestionOptions(question_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT OPTION FROM OptionsMultipleChoice WHERE question_id = '${question_id}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let json = JSON.parse(JSON.stringify(results));
                    const transformedArray = json.map(option => parseInt(option.OPTION));
                    resolve(transformedArray);
                } else {
                    resolve([]);
                }
            }
        });
    });
}

/**
 * Retorna si la respuesta es correcta o no, verifica si es una pregunta de desarrollo
 * 
 * @param {String} exam_id - id del examen al que quieres chequear el numero de.
 * @param {String} answer - respuesta que se dio en el examen.
 * @returns {int} devuelve 0, si la respuesta es incorrecta, 1, si es correcta y -1 en caso de que sea una pregunta de desarrollo y por lo tanto no se puede evaluar automaticamente.
 */
function checkAnswer(exam_id, answer) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT checkAnswer('${exam_id}', '${answer}') AS is_correct`;
        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let is_correct = JSON.parse(JSON.stringify(results))[0].is_correct;
                    resolve(is_correct);
                } else {
                    resolve(-1);
                }
            }
        });
    });
}
/**
 * Chequea la nota maxima que puedes tener en una pregunta 
 * 
 * @param {String} question_id - id de la pregunta al que quieres chequear el max_score.
 * @returns {Float} nota que saco el estudiante en esa pregunta, puede ser null en caso de error.
 */
function checkMaxScore(question_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT max_score FROM Questions WHERE question = '${question_id}'`;
        
        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let  max_score = JSON.parse(JSON.stringify(results))[0].max_score;
                    resolve(parseFloat(max_score).toFixed(1));
                } else {
                    resolve(null);
                }
            }
        });
    });
}

/**
 * Inserta en la tabla Grades la nota de ese examen del estudiante
 * 
 * @param {String} exam_id - id del examen que se realizo.
 * @param {String} student_id - id del estudiante que realizo el examen.
 * @param {String} date - fecha en la que el estudiante realizo el examen.
 * @param {String} score - calificacion que saco en el examen.
 * @returns {json} arreglar esto para que mande un boolean.
 */
function insertGrades(exam_id, student_id, date, score) {
    return new Promise((resolve, reject) => {
        const sql = `INSERT INTO Grades (exam_id, student_id, test_date, score)
        VALUES (?, ?, ?, ?)`;

        let values = [exam_id, student_id, date, score];

        conn.query(sql, values, (error, result) => {
            if (error) {
                console.log(error.sql);
                reject(error);
            } else {
                resolve(result);
            }
        });
    });
}

function getExam(exam_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT name as exam_id FROM Exams WHERE required_block = ${exam_id}`;
        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                console.log(results);
                if (results.length > 0) {
                    
                    resolve(results[0]);
                } else {
                    resolve(null);
                }
            }
        });
    });
}

  
module.exports = {
    getNumQuestions,
    getQuestions,
    getQuestionOptions,
    getGeneratedTestsQuestions,
    checkAnswer,
    checkMaxScore,
    insertGrades,
    getExam
    // Otras funciones separadas por comas...
};