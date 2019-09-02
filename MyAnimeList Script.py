import psycopg2
#tentativa2
def printa_consultas():
    print("Consultas Disponiveis: \n");
    print("1 - Para cada estudio, todos os seus animes em ordem alfabetica\n")
    print("2 - O anime de um tipo, gênero e estudio a sua escolha de maior nota\n")
    print("3 - O código da lista de anime de cada usuário com lista publica e os títulos dos animes da lista\n")
    print("4 - Mangás de um gênero e autor a sua escolha\n")
    print("5 - Moderadores que postaram sobre One Piece e participam do clube clamp stans\n")
    print("6 - Os usuarios que não participam dos mesmos clubes que um usuario de sua escolha mas que são amigos dele\n\n")
    print("Consultas com visoes Disponiveis: \n")
    print("7 - Verifica se anime digitado pelo usuário está na lista de fmarocks\n")
    print("8 - Conta o número de animes da lista de fmarocks\n")
	
def consultaN1(conn):
    cur = conn.cursor()
    cur.execute("select nomeestudio, count(distinct nomeanime) as nroobras, nomeanime, nomepessoa, nomefunc from anime natural join estudioAnime natural join producao group by nomeestudio, nomeanime, nomepessoa, nomefunc;")
    rows = cur.fetchall()
    rows
    print()
    print("Estudio                  N°Animes                 Anime                    Staff                    Funcao")
    for row in rows:
        for item in row:
            print('{:<25}'.format(item), end = '')
        print()
    print("\n\n")
    cur.close()
	
def consultaN2(conn):
    tipo = input("Digite um tipo de anime valido (Filme, TV, Especial, OVA, ou ONA): ")
    estudio = input("Digite um estudio de animacao existente: ")
    genero = input("Digite um genero de anime existente: ")
    cur = conn.cursor()
    cur.execute("select nomeanime from anime where medpontos IN (select max(medpontos) from anime natural join caracterizacaoAnime natural join estudioAnime where tipo = '" + tipo + "' AND nomeestudio = '" + estudio +"' AND nomeg = '" + genero + "')")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()
	
def consultaN3(conn):
    cur = conn.cursor()
    cur.execute("select nomeu, listaA, nomeanime from usuario natural join contencaoListaAnimes natural join listaAnime where privacidade = 'publica' group by nomeu, nomeanime order by listaA, nomeanime")
    rows = cur.fetchall()
    rows
    print()
    print("Usuario                 codigo                  Anime")
    for row in rows:
        for item in row:
            print('{:<24}'.format(item), end = '')
        print()
    print("\n\n")
    cur.close()
	
def consultaN4(conn):
    autor = input("Digite um autor existente: ")
    genero = input("Digite um genero de manga existente: ")
    cur = conn.cursor()
    cur.execute("select nomemanga from manga where nomemanga IN (select nomemanga from caracterizacaoManga where nomeg = '" + genero + "') AND nomemanga IN (select nomemanga from criacao where nomepessoa = '" + autor + "')")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()
	
def consultaN5(conn):
    cur = conn.cursor()
    cur.execute("select nomemod from moderador where nomemod IN (select nomemod from postagem natural join assuntoanime where nomeanime = 'One Piece') AND nomemod IN (select nomeu as nomemod from participacao where nomec = 'clamp stans')")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()
	
def consultaN6(conn):
    user = input("Digite um usuário existente: ")
    cur = conn.cursor()
    cur.execute("select nomeu from usuario u1 where NOT EXISTS (select * from participacao where nomeu = u1.nomeu and nomec in (select nomec from participacao where nomeu = '" + user + "')) AND EXISTS (select * from amizade where (fstusuario = u1.nomeu and sndusuario = '" + user + "') or (sndusuario = u1.nomeu and fstusuario = '" + user + "'))")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()

def consultaN7(conn):
    anime = input("Digite o nome do anime: ")
    cur = conn.cursor()
    cur.execute("select nomeanime from ListaDoUsuario where nomeanime = '" + anime + "'")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()

def consultaN8(conn):
    cur = conn.cursor()
    cur.execute("select count(distinct nomeanime) from ListaDoUsuario")
    rows = cur.fetchall()
    rows
    print()
    for row in rows:
        for item in row:
            print(item)
    print("\n\n")
    cur.close()

def consultas(conn):
    opcao = 0
    while(opcao < 1 or opcao > 8):
        printa_consultas()
        opcao = int(input("Digite o numero referente a consulta que desejas: "))
        if opcao < 1 or opcao > 8:
            print("Digite uma opcao valida\n")
    if opcao == 1:
        consultaN1(conn)
    elif opcao == 2:
        consultaN2(conn)
    elif opcao == 3:
        consultaN3(conn)
    elif opcao == 4:
        consultaN4(conn)
    elif opcao == 5:
        consultaN5(conn)
    elif opcao == 6:
        consultaN6(conn)
    elif opcao == 7:
        consultaN7(conn)
    elif opcao == 8:
        consultaN8(conn)

def insereAnime(conn):
    anime = input("Digite o nome do anime (80 chars): ")
    lista = input("Digite o codigo da lista (inteiro): ")
    nota = input("Digite a nota de 0 a 10 (inteiro): ")
    categoria = input("Digite a categoria (Assistindo, Completo, EmEspera, Desistido, ou PlanejadoParaAssistir): ")
    progresso = input("Digite o numero de episodios vistos (inteiro): ")
    inicio = input("Digite a data de inicio em formato DD/MM/AAAA (ou 0 caso não queria): ")
    if inicio == "0":
        inicio = "NULL"
    else:
        inicio = "'" + inicio + "'"
    fim = input("Digite a data de finalização em formato DD/MM/AAAA (ou 0 caso não queria): ")
    if fim == "0":
        fim = "NULL"
    else:
        fim = "'" + fim + "'"
    cur = conn.cursor()
    cur.execute("select medpontos from anime where nomeanime = '" + anime + "'")
    rows = cur.fetchall()
    rows
    print()
    print("Média de todas as notas do anime", anime, ": ", end = '')
    for row in rows:
        for item in row:
            print(item)
    cur.execute("insert into contencaoListaAnimes values('" + anime + "', " + lista + ", " + nota + ", '" + categoria + "', " + progresso + ", " + inicio + ", " + fim + ");")
    cur.execute("select medpontos from anime where nomeanime = '" + anime + "'")
    rows = cur.fetchall()
    rows
    print()
    print("Nova média de todas as notas do anime", anime, ": ", end = '')
    for row in rows:
        for item in row:
            print(item)
    conn.commit()
    cur.close()

def insereManga(conn):
    manga = input("Digite o nome do manga (80 chars): ")
    lista = input("Digite o codigo da lista (inteiro): ")
    nota = input("Digite a nota de 0 a 10 (inteiro): ")
    categoria = input("Digite a categoria (Lendo, Completo, EmEspera, Desistido, ou PlanejadoParaLer): ")
    progresso = input("Digite o numero de capítulos lidos (inteiro): ")
    inicio = input("Digite a data de inicio em formato DD/MM/AAAA (ou 0 caso não queria): ")
    if inicio == "0":
        inicio = "NULL"
    else:
        inicio = "'" + inicio + "'"
    fim = input("Digite a data de finalização em formato DD/MM/AAAA (ou 0 caso não queria): ")
    if fim == "0":
        fim = "NULL"
    else:
        fim = "'" + fim + "'"
    cur = conn.cursor()
    cur.execute("select medpontos from manga where nomemanga = '" + manga + "'")
    rows = cur.fetchall()
    rows
    print()
    print("Média de todas as notas do mangá", manga, ": ", end = '')
    for row in rows:
        for item in row:
            print(item)
    cur.execute("insert into contencaoListaMangas values('" + manga + "', " + lista + ", " + nota + ", '" + categoria + "', " + progresso + ", " + inicio + ", " + fim + ");")
    cur.execute("select medpontos from manga where nomemanga = '" + manga + "'")
    rows = cur.fetchall()
    rows
    print()
    print("Nova média de todas as notas do mangá", manga, ": ", end = '')
    for row in rows:
        for item in row:
            print(item)
    conn.commit()
    cur.close()

def menu():
	opcao = 0
	while(opcao < 1 or opcao > 4):
		print("O que você deseja fazer:\n")
		print("1 - Inserir um anime na lista de um usuario\n")
		print("2 - Inserir um manga na lista de um usuario\n")
		print("3 - Consultas\n")
		print("4 - Desconectar e sair\n")
		opcao = int(input("Digite o numero correspondente a opcao: "))
		if opcao < 1 or opcao > 4:
			print("Digite uma opcao valida\n")
	return opcao
 
def connect():
    """ Conexão a base de dados PostgreSQL"""
    conn = None
    try: 
        # conecção ao server PostgreSQL 
        print("Conectando a base de dados PostgreSQL ...")
        conn = psycopg2.connect("dbname=MyAnimeList user=aluno password=aluno host=localhost")
        print("Conectado")
        opcao = 0
        while opcao != 4:
            opcao = menu()
            if opcao == 1:
                print("insercao anime trigger")
                insereAnime(conn)
            elif opcao == 2:
                print("insercao manga trigger")
                insereManga(conn)
            elif opcao == 3:
                consultas(conn)
     # encerra a comunicacao com o PostgreSQL
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Conexao com a base de dados fechada.')
 

if __name__ == '__main__':
    connect()
