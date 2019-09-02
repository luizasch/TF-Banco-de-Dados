-- Sempre que for inserido na tabela contencaoListaAnimes ou contencaoListaMangas, a obra que foi inserida terá sua média de pontos recalculada
-- Para animes
drop function if exists recalculamediaA() cascade;
CREATE OR REPLACE FUNCTION recalculamediaA() returns trigger as $sucesso$
	begin
		update anime
		set medpontos = (select AVG(nota)
						from contencaoListaAnimes
						where nomeanime = new.nomeanime)
		where nomeanime = new.nomeanime;
		return NULL;
	end;
$sucesso$ LANGUAGE plpgsql;


create trigger recalcula_media_anime
after insert on contencaoListaAnimes
for each row
execute procedure recalculamediaA();

-- Para mangás
drop function if exists recalculamediaM() cascade;
CREATE OR REPLACE FUNCTION recalculamediaM() returns trigger as $sucesso$
	begin
		update manga
		set medpontos = (select AVG(nota)
						from contencaoListaMangas
						where nomemanga = new.nomemanga)
		where nomemanga = new.nomemanga;
		return NULL;
	end;
$sucesso$ LANGUAGE plpgsql;


create trigger recalcula_media_manga
after insert on contencaoListaMangas
for each row
execute procedure recalculamediaM();