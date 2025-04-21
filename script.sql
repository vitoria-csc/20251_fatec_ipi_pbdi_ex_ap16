-- 1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.

DO $$
DECLARE
	cur_sports_music_maior1000 CURSOR FOR SELECT rank, youtuber FROM tb_top_youtubers WHERE video_count >= 1000;
	tupla RECORD;
	resultado TEXT DEFAULT '';
BEGIN
	OPEN cur_sports_music_maior1000;
	FETCH cur_sports_music_maior1000 INTO tupla;
	WHILE FOUND LOOP
		resultado := resultado || tupla.rank || ':' || tupla.youtuber || ',';
		FETCH cur_sports_music_maior1000 INTO tupla;
	END LOOP;
	CLOSE cur_sports_music_maior1000;
	RAISE NOTICE '%', resultado;
END;
$$

--1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa.
DO $$
DECLARE
    cur_youtubers REFCURSOR;
	tupla RECORD;
BEGIN
    OPEN cur_youtubers SCROLL FOR 
	SELECT youtuber 
	FROM tb_top_youtubers 
	ORDER BY youtuber ASC;
    
   LOOP
        FETCH cur_youtubers INTO tupla;
        EXIT WHEN NOT FOUND;
    END LOOP;
    LOOP
        FETCH BACKWARD FROM cur_youtubers INTO tupla;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%', tupla.youtuber;
    END LOOP;
    CLOSE cur_youtubers;
END;
$$

--1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row. Explique com suas palavras do que se trata.
-- RBAR, sigla para “Row By Agonizing Row”, é um anti-padrão comum em bancos de dados relacionais, especialmente quando se utiliza SQL de forma procedural - prática de processar registros um a um, geralmente dentro de loops, ao invés de utilizar operações em conjunto. 
-- O principal problema do RBAR é o impacto negativo no desempenho, principalmente em tabelas grandes. Quando cada linha é tratada individualmente, o banco de dados realiza muito mais operações internas, o que resulta em tempo de execução maior, maior uso de recursos e maior complexidade no código. Apesar disso, há situações específicas em que o RBAR pode ser necessário, como em processos que exigem lógica muito específica ou tratamento linha a linha, mas esses casos são exceções. O uso preferencial deve ser sempre por abordagens set-based, nas quais se consegue aplicar uma mesma operação a várias linhas com um único comando SQL, aproveitando a verdadeira força dos bancos relacionais.