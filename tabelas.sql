-- Tabelas referentes a lista de animes e lista de mangás

create table listaAnime
(idlistaA int not null,
privacidade char(7),			-- Somente Publica ou Privada
templatelista varchar(8),	-- Somente Classico ou Moderno
primary key (idlistaA)
);

create table listaManga
(idlistaM int not null,
privacidade char(7),			-- Somente Publica ou Privada
templatelista varchar(8),		-- Somente Classico ou Moderno
primary key (idlistaM)
);

-- Tabelas referentes a usuário e pefil (fusão)

create table usuario
(nomeu varchar(16) not null, 	-- Nome de usuário
email varchar(200) not null,
senha varchar(50) not null,
datanasc date not null,			-- Data de Nascimento
datacad date not null,			-- Data de Cadastramento
genero varchar(12) not null,	-- Somente Masculino, Feminino ou NaoBinario
pais varchar(40) not null,		-- Localizacao
listaA int not null,
listaM int not null,
primary key(nomeu),
unique(email),
foreign key(listaA) references listaAnime,
foreign key(listaM) references listaManga
);

-- Usuário especial: Moderador

create table moderador
(nomemod varchar(16) not null primary key, 	-- Nome de usuário
foreign key(nomemod) references usuario
);

-- Tabela amizade representa o relacionamento amizade entre dois usuários

create table amizade
(fstusuario varchar(16) not null,
sndusuario varchar(16) not null,
primary key (fstusuario, sndusuario),
foreign key (fstusuario) references usuario,
foreign key (sndusuario) references usuario
);

create table clube
(nomec varchar(100) not null,
categoria varchar(70) not null,
acesso char(7) not null,					-- Somente Privado, Publico ou Secreto
datacriacao date not null,
quantmembros int not null check(quantmembros >= 0),
primary key(nomec)
);

create table topico
(titulo varchar(150) not null,
criador varchar(16) not null,
nomec varchar(100) not null,
primary key(titulo),
foreign key(criador) references usuario,
foreign key(nomec) references clube
);

-- Tabela resposta representa o relacionamento resposta entre topico e usuario
 
create table resposta
(nomeu varchar(16) not null,
nometopico varchar(150) not null,
primary key(nomeu, nometopico),
foreign key (nomeu) references usuario
);

-- Tabela participacao representa o relacionamento participação entre clube e usuario

create table participacao
(nomeu varchar(16) not null,
nomec varchar(100) not null,
primary key (nomeu, nomec),
foreign key (nomeu) references usuario,
foreign key(nomec) references clube
);

-- Tabelas relacionadas as postagens de moderadores

create table marcacao
(idmarcacao varchar(20) not null primary key);

create table postagem
(titulo varchar(200) not null,
datap date not null,
tipopostagem varchar(7) not null,			-- Somente notícia ou artigo
nomemod varchar(16) not null,
primary key(titulo),
foreign key(nomemod) references moderador
);

-- Tabela marcaPostagem é uma nova tabela para representar o novo relacionamento de uma postagem com várias marcações

create table marcaPostagem
(titulopost varchar(200) not null,
idmarcacao varchar(20) not null,
primary key (titulopost, idmarcacao),
foreign key (titulopost) references postagem,
foreign key (idmarcacao) references marcacao
);

-- Tabelas referentes a anime

create table abertura
(nomeabertura varchar(100) not null primary key);

create table encerramento
(nomeencer varchar(100) not null primary key);

create table produtora
(nomeprod varchar(70) not null primary key);

create table licenciador
(nomelicen varchar(70) not null primary key);

create table estudio
(nomeestudio varchar(70) not null primary key);

create table anime
(nomeanime varchar(80) not null,
medpontos real check(medpontos between 0 and 10),		-- Media de Pontuação
rankpontos int check(rankpontos > 0),					-- Posição no Ranking de Pontuação
quantmembros int check(quantmembros >= 0),				-- Quantidade de membros
rankpopular int check(rankpopular > 0),					-- Posição no Ranking de Popularidade
episodios int not null check(episodios >= 0),
status varchar(18),										-- Somente EmLancamento, Finalizado, ou AindaNaoLancado
premiere date not null,
duracao int not null check(duracao > 0),
tipo varchar(8),										-- Somente Filme, TV, Especial, OVA, ou ONA
primary key (nomeanime)
);

-- Tabela aberturaAnime é uma nova tabela para representar o novo relacionamento de um anime com várias aberturas

create table aberturaAnime
(nomeanime varchar(80) not null,
nomeabertura varchar(100) not null,
primary key(nomeanime, nomeabertura),
foreign key (nomeanime) references anime,
foreign key (nomeabertura) references abertura
);

-- Tabela encerramentoAnime é uma nova tabela para representar o novo relacionamento de um anime com vários encerramentos

create table encerramentoAnime
(nomeanime varchar(80) not null,
nomeencer varchar(100) not null,
primary key(nomeanime, nomeencer),
foreign key (nomeanime) references anime,
foreign key (nomeencer) references encerramento
);

-- Tabela produtoraAnime é uma nova tabela para representar o novo relacionamento de um anime com várias produtoras

create table produtoraAnime
(nomeanime varchar(80) not null,
nomeprod varchar(100) not null,
primary key(nomeanime, nomeprod),
foreign key (nomeanime) references anime,
foreign key (nomeprod) references produtora
);

-- Tabela licenciadorAnime é uma nova tabela para representar o novo relacionamento de um anime com vários licenciadores

create table licenciadorAnime
(nomeanime varchar(80) not null,
nomelicen varchar(100) not null,
primary key(nomeanime, nomelicen),
foreign key (nomeanime) references anime,
foreign key (nomelicen) references licenciador
);

-- Tabela estudioAnime é uma nova tabela para representar o novo relacionamento de um anime com vários estudios

create table estudioAnime
(nomeanime varchar(80) not null,
nomeestudio varchar(100) not null,
primary key(nomeanime, nomeestudio),
foreign key (nomeanime) references anime,
foreign key (nomeestudio) references estudio
);

-- Tabela contencaoListaAnimes é uma nova tabela para representar o relacionamento contancao entre animes e lista de animes

create table contencaoListaAnimes
(nomeanime varchar(80) not null,
listaA int not null,
nota int not null check(nota between 0 and 10),
categoria varchar(24) not null,				-- Somente Assistindo, Completo, EmEspera, Desistido, ou PlanejadoParaAssistir
progresso int not null,
inicio date,
finalizacao date,
primary key (nomeanime, listaA),
foreign key (nomeanime) references anime,
foreign key(listaA) references listaAnime
);

-- Tabela mangá

create table manga
(nomemanga varchar(80) not null,
medpontos real check(medpontos between 0 and 10),	-- Media de Pontuação
rankpontos int check(rankpontos > 0),				-- Posição no Ranking de Pontuação
quantmembros int check(quantmembros >= 0),			-- Quantidade de membros
rankpopular int check(rankpopular > 0),				-- Posição no Ranking de Popularidade
capitulos int not null check(capitulos >= 0),
volumes int not null check(volumes >= 0),
status varchar(18),									-- Somente Em Lancamento, Finalizado, ou Ainda Nao Lancado
publicacao date not null,
tipo varchar(9) not null,							-- Somente Manga, Novel, OneShot, Doujinshi, Manhwa, ou Manhua
revista varchar(70),
primary key (nomemanga)
);

-- Tabela contencaoListaMangas é uma nova tabela para representar o relacionamento contancao entre mangas e lista de mangas

create table contencaoListaMangas
(nomemanga varchar(80) not null,
listaM int not null,
nota int not null check(nota between 0 and 10),
categoria varchar(20) not null,					-- Somente Lendo, Completo, EmEspera, Desistido, ou PlanejadoParaLer
progresso int not null check(progresso >= 0),
inicio date,
finalizacao date,
primary key (nomemanga, listaM),
foreign key (nomemanga) references manga,
foreign key(listaM) references listaManga
);

-- Tabela personagem

create table personagem
(nomepers varchar(70) not null primary key);

-- Tabela participaPersonagemAnime representa o relacionamento participacao entre anime e personagem

create table participaPersonagemAnime
(nomepers varchar(70) not null,
nomeanime varchar(80) not null,
primary key (nomepers, nomeanime),
foreign key (nomepers) references personagem,
foreign key (nomeanime) references anime
);

-- Tabela participaPersonagemManga representa o relacionamento participacao entre manga e personagem

create table participaPersonagemManga
(nomepers varchar(70) not null,
nomemanga varchar(80) not null,
primary key (nomepers, nomemanga),
foreign key (nomepers) references personagem,
foreign key (nomemanga) references manga
);

-- Tabela genero

create table genero
(nomeg varchar(25) not null primary key);

-- Tabela caracterizacaoAnime representa o relacionamento caracterizacao entre anime e genero

create table caracterizacaoAnime
(nomeg varchar(25) not null,
nomeanime varchar(80) not null,
primary key (nomeg, nomeanime),
foreign key (nomeg) references genero,
foreign key (nomeanime) references anime
);

-- Tabela caracterizacaoManga representa o relacionamento caracterizacao entre manga e genero

create table caracterizacaoManga
(nomeg varchar(25) not null,
nomemanga varchar(80) not null,
primary key (nomeg, nomemanga),
foreign key (nomeg) references genero,
foreign key (nomemanga) references manga
);

-- Tabela criticaAnime representa o relacionamento critica entre anime e usuario

create table criticaAnime
(nomeanime varchar(80) not null,
nomeu varchar(16) not null,
nota int not null check(nota between 0 and 10),
publicacao date not null,
primary key (nomeanime, nomeu),
foreign key (nomeanime) references anime,
foreign key (nomeu) references usuario
);

-- Tabela criticaManga representa o relacionamento critica entre manga e usuario

create table criticaManga
(nomemanga varchar(80) not null,
nomeu varchar(16) not null,
nota int not null check(nota between 0 and 10),
publicacao date not null,
primary key (nomemanga, nomeu),
foreign key (nomemanga) references manga,
foreign key (nomeu) references usuario
);

-- Tabelas referentes a pessoa da indústria

create table staff
(nomepessoa varchar(70) not null,
datanasc date not null,
primary key (nomepessoa)
);

create table dublador
(nomepessoa varchar(70) not null,
datanasc date not null,
primary key (nomepessoa)
);

create table mangaka
(nomepessoa varchar(70) not null,
datanasc date not null,
primary key (nomepessoa)
);

-- Tabela dublagem representa o relacionamento entre personagem e dublador

create table dublagem
(nomepessoa varchar(70) not null,
nomepers varchar(70) not null,
primary key (nomepessoa, nomepers),
foreign key (nomepessoa) references dublador,
foreign key (nomepers) references personagem
);

-- Tabela funcao é uma nova tabela que representa os antigos atributos funcao nos relacionamentos producao (entre staff e anime) e criacao (entre manga e mangaka)

create table funcao
(nomefunc varchar(20) not null primary key);

-- Tabela criacao representa o relacionamento entre mangaka e manga

create table criacao
(nomepessoa varchar(70) not null,
nomemanga varchar(80) not null,
nomefunc varchar(20) not null,
primary key (nomepessoa, nomemanga, nomefunc),
foreign key (nomepessoa) references mangaka,
foreign key (nomemanga) references manga,
foreign key (nomefunc) references funcao
);

-- Tabela producao representa o relacionamento entre staff e anime

create table producao
(nomepessoa varchar(70) not null,
nomeanime varchar(80) not null,
nomefunc varchar(20) not null,
primary key (nomepessoa, nomeanime, nomefunc),
foreign key (nomepessoa) references staff,
foreign key (nomeanime) references anime,
foreign key (nomefunc) references funcao
);

-- Tabela assuntoAnime representa o relacionamento entre postagem e anime

create table assuntoAnime
(titulo varchar(200) not null,
nomeanime varchar(80) not null,
primary key (titulo, nomeanime),
foreign key (titulo) references postagem,
foreign key (nomeanime) references anime
);

-- Tabela assuntoManga representa o relacionamento entre postagem e manga

create table assuntoManga
(titulo varchar(200) not null,
nomemanga varchar(80) not null,
primary key (titulo, nomemanga),
foreign key (titulo) references postagem,
foreign key (nomemanga) references manga
);

-- Tabela assuntoStaff representa o relacionamento entre postagem e staff

create table assuntoStaff
(titulo varchar(200) not null,
nomepessoa varchar(80) not null,
primary key (titulo, nomepessoa),
foreign key (titulo) references postagem,
foreign key (nomepessoa) references staff
);

-- Tabela assuntoDublador representa o relacionamento entre postagem e dublador

create table assuntoDublador
(titulo varchar(200) not null,
nomepessoa varchar(80) not null,
primary key (titulo, nomepessoa),
foreign key (titulo) references postagem,
foreign key (nomepessoa) references dublador
);

-- Tabela assuntoMangaka representa o relacionamento entre postagem e mangaka

create table assuntoMangaka
(titulo varchar(200) not null,
nomepessoa varchar(80) not null,
primary key (titulo, nomepessoa),
foreign key (titulo) references postagem,
foreign key (nomepessoa) references mangaka
);

