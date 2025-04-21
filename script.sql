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