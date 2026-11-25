/* =====================================================================
   PROVA - LABORATÓRIO DE BANCO DE DADOS - CLÍNICA VETERINÁRIA
   Nome: ______________________________
   Matrícula: _________________________
   ===================================================================== */

USE clinica_vet;

-- Questão 1
SELECT v.nome,
       v.especialidade,
       COUNT(c.id_consulta) AS quantidade_consultas,
       SUM(c.valor)         AS total_faturado
FROM veterinario v
INNER JOIN consulta c ON c.id_veterinario = v.id_veterinario
WHERE c.status = 'Realizada'
GROUP BY v.id_veterinario, v.nome, v.especialidade
HAVING SUM(c.valor) > 800.00
ORDER BY total_faturado DESC;


-- Questão 2
SELECT a.nome,
       a.especie,
       COUNT(c.id_consulta) AS quantidade_consultas
FROM animal a
LEFT JOIN consulta c ON c.id_animal = a.id_animal
GROUP BY a.id_animal, a.nome, a.especie
ORDER BY quantidade_consultas DESC, a.nome ASC;


-- Questão 3
DROP TRIGGER IF EXISTS trg_historico_peso;

DELIMITER $$
CREATE TRIGGER trg_historico_peso
AFTER UPDATE ON animal
FOR EACH ROW
BEGIN
    IF NEW.peso <> OLD.peso THEN
        INSERT INTO historico_peso (id_animal, peso_anterior, peso_novo, data_alteracao, usuario)
        VALUES (NEW.id_animal, OLD.peso, NEW.peso, NOW(), CURRENT_USER());
    END IF;
END$$
DELIMITER ;

-- 3.1 UPDATE do peso do Thor
UPDATE animal
SET peso = 33.10
WHERE id_animal = 1;

-- 3.2 SELECT do registro gravado
SELECT *
FROM historico_peso
WHERE id_animal = 1;


-- Questão 4
-- 4.1 Criar o usuário
CREATE USER 'recepcao_vet'@'localhost' IDENTIFIED BY 'Recepcao@2026';

-- 4.2 Conceder todos os privilégios no banco clinica_vet
GRANT ALL PRIVILEGES ON clinica_vet.* TO 'recepcao_vet'@'localhost';

-- 4.3 Revogar UPDATE e DELETE no banco clinica_vet
REVOKE UPDATE, DELETE ON clinica_vet.* FROM 'recepcao_vet'@'localhost';

FLUSH PRIVILEGES;
