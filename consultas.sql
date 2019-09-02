-- 1) Para cada estúdio, seu nome, o número e os títulos de suas produções, junto com o
-- nome das pessoas da indústria que trabalharam nessa produção e sua função na produção

select nomeestudio, count(distinct nomeanime) as nroobras, nomeanime, nomepessoa, nomefunc
from anime natural join estudioAnime natural join producao 
group by nomeestudio, nomeanime, nomepessoa, nomefunc;


-- 2) O anime do tipo TV de Comedia do estúdio Toei Animation de maior nota

select nomeanime
from anime 
where medpontos IN (select max(medpontos)
				  from anime natural join caracterizacaoAnime natural join estudioAnime
				  where tipo = 'TV' AND nomeestudio = 'Toei Animation' AND nomeg = 'Comedia');
	
				  
-- 3) O código da lista de anime de cada usuário com lista pública e os títulos dos animes da lista

select nomeu, listaA, nomeanime 
from usuario natural join contencaoListaAnimes natural join listaAnime
where privacidade = 'publica'
group by nomeu, nomeanime
order by listaA, nomeanime;


-- 4) Mangás do gênero supernatural escritos por Hirohiko Araki

select nomemanga
from manga
where nomemanga IN (select nomemanga 
			from caracterizacaoManga
			where nomeg = 'Supernatural')
			AND nomemanga IN (select nomemanga
					from criacao
					where nomepessoa = 'Hirohiko Araki');
							
							
-- 5) Moderadores que postaram sobre One Piece e participam do clube clamp stans 
	
select nomemod 
from moderador
where nomemod IN (select nomemod 
				from postagem natural join assuntoanime
				where nomeanime = 'One Piece')
          AND nomemod IN (select nomeu as nomemod 
						from participacao
						where nomec = 'clamp stans');
	

-- 6) Os usuarios que não participam dos mesmos clubes que o usuario X mas que são amigos dele

select nomeu
from usuario u1
where NOT EXISTS (select *
			from participacao
			where nomeu = u1.nomeu and nomec in (select nomec
								from participacao
								where nomeu = 'junjitostan'))
		AND EXISTS (select *
			from amizade
			where (fstusuario = u1.nomeu and sndusuario = 'junjitostan') or (sndusuario = u1.nomeu and fstusuario = 'junjitostan'));

-- Visão que mostra a lista de animes de um usuário (fmarocks)
create view ListaDoUsuario
as select nomeanime
from usuario natural join listaAnime natural join contencaoListaAnimes
where nomeu = 'fmarocks';

-- 7) Verifica se anime Fullmetal Alchemist: Brotherhood Specials está nessa lista
select nomeanime
from ListaDoUsuario
where nomeanime = 'Fullmetal Alchemist: Brotherhood Specials';

-- 8) Conta o número de animes daquela lista
select count(distinct nomeanime)
from ListaDoUsuario;


				