/*Sprint 3 - Nivell 1

- Exercici 1
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company").
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit".
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.*/
    
CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(20) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(30),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    expiring_date VARCHAR(20));

SELECT *
FROM credit_card;


# Afegir l'id de credit card com a foreign key de transaction

ALTER TABLE transaction 
ADD CONSTRAINT fk_credit_card_id 
FOREIGN KEY (credit_card_id) 
REFERENCES credit_card(id);



/*- Exercici 2
El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.*/

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';


/*- Exercici 3
En la taula "transaction" ingressa un nou usuari amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0*/

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', 829.999, -117.999, 111.11, 0);

SELECT *
FROM company
WHERE id = 'b-9999';

INSERT INTO company (id)
VALUES ('b-9999');

SELECT *
FROM transaction
WHERE company_id = 'b-9999';



/*- Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.*/

ALTER TABLE credit_card DROP COLUMN pan;

SELECT *
FROM credit_card;



/*Sprint 3 - Nivell 2
- Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.*/

SELECT * 
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

DELETE FROM transaction 
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';
 
 /*-Exercici 2
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. 
Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.*/

CREATE VIEW vista_marketing AS
SELECT c.company_name as Nom_companyia, c.phone as Telèfon, c.country as País, ROUND(AVG(t.amount), 2) as Mitjana_vendes
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name, c.phone, c.country
ORDER BY Mitjana_vendes DESC;

SELECT *
FROM vista_marketing;




/*Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"*/

SELECT *
FROM vista_marketing
WHERE País = 'Germany';


/*Sprint 3 - Nivell 3- Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:*/

#Creo la taula "user"

CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)    
    );
    
# Comprovo que la taula "user" s'ha carregat correctament

SELECT * 
from user;


# Afegir l'id de user com a foreign key de transaction

ALTER TABLE transaction 
ADD CONSTRAINT fk_user_id 
FOREIGN KEY (user_id) 
REFERENCES user(id);


# Elimino la columna "website" de la taula "company"
ALTER TABLE company 
DROP COLUMN website;

# Comprovo que la columna "website" s'ha eliminat correctament
SELECT *
FROM company;

# Afegeixo la columna "fecha_actual" a la taula "credit_card"
ALTER TABLE credit_card
ADD fecha_actual DATE;

# Comprovo que s'ha aplicat el canvi
SELECT *
FROM credit_card;

# Canvio el nom de la taula "user", que passarà a dir-se "data_user"
RENAME TABLE user
TO data_user;

# Canvio el nom del camp "email" de la rebatejada taula "data_user", que passarà a dir-se "personal_email"
ALTER TABLE data_user
RENAME COLUMN email to personal_email;

# Comprovo que s'han fet els canvis
SELECT personal_email
FROM data_user;


/*- Exercici 2
L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:

ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/


CREATE VIEW informetecnico AS
SELECT t.id as ID_transacció, du.name as Nom_usuari, du.surname as Cognom_usuari, cc.iban as Iban, c.company_name as Nom_companyia
FROM transaction t
JOIN credit_card cc
ON t.credit_card_id = cc.id
JOIN company c
ON c.id = t.company_id
JOIN data_user du
ON du.id = t.user_id
ORDER BY ID_transacció DESC;

SELECT *
FROM informetecnico;


