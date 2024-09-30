# Sažetak
Cilj ovog završnog rada je istražiti Flutter okvir za razvoj mobilnih/desktop aplikacija. U sklopu
rada će biti osmišljena, razvijena i testirana aplikacija Restoran u kojoj su implementirane četiri razine
uloga korisnika. Dok administrator ima sve ovlasti u aplikaciji, uloga klijenta pruža uvid u jelovnik i
trenutni broj slobodnih stolova, a uloge konobar i kuhar podržavaju rad s narudžbama te međusobnu
komunikaciju. U prvom dijelu rada opisane su korištene tehnologije i funkcionalnosti aplikacije, a u
središnjem dijelu detaljnije je prikazan razvoj aplikacije u Flutteru. Autentifikacija korisnika i baza
podataka implementirana je pomoću usluga koje pruža Firebase.

# Opis
Za izradu aplikacije korišten je Flutter razvojni okvir, uređivač koda Visual Studio Code, a za autentifikaciju i
uporabu baze podataka koriste se usluge koje pruža Firebase. Funkcionalni cilj aplikacije je pružiti
pregled glavnih stavki Restorana koje bi mogle zanimati posjetitelje i koristiti radnom osoblju.
Unutar aplikacije korisnik koji nije prijavljen ima mogućnost saznati broj trenutno slobodnih
stolova, telefonski broj restorana i omogućen mu je pregled jelovnika hrane i pića. Radno osoblje za
svoje potrebe mora biti prijavljeno i ima dodatne opcije ovisno o njihovoj ulozi koja može biti konobar,
kuhar i administrator.

Konobar ima funkciju rezerviranje i dodavanja narudžbi za određeni stol, može dodati hranu ili
piće koje se nalazi u jelovniku i u slučaju zauzetog stola dobiva povratnu informaciju zauzeća. Narudžba
hrane koju unosi konobar automatski se prosljeđuje na prikaz kuharu. 

Uloga kuhara omogućava označavanje napravljene narudžbe te automatsko dodavanje označene narudžbe na listu gotovih jela
kojoj mogu pristupiti korisnici u ulogama konobara i kuhara. Dodatno, konobar ima funkciju
oslobođenja stola i brisanja narudžbi stola. 

Uloga administratora omogućava dodavanje, uređivanje i
brisanje korisničkih računa zaposlenika iz baze podataka, te ima opcije prikaza i korištenja svih
funkcionalnosti implementiranih za ostale uloge.

# Summary
The aim of this final project is to explore the Flutter framework for the development of mobile/desktop applications. As part of the project, a Restaurant application will be designed, developed, and tested, where four levels of user roles are implemented. While the administrator has all the permissions in the application, the client role provides an overview of the menu and the current number of available tables, and the waiter and chef roles support order management and mutual communication. The first part of the work describes the technologies and functionalities used in the application, while the central part provides a more detailed overview of the development of the application in Flutter. User authentication and the database are implemented using services provided by Firebase.

# Description
The Flutter development framework was used to create the application, with Visual Studio Code as the code editor, and Firebase services were used for authentication and database management. The functional goal of the application is to provide an overview of the main features of the Restaurant that may interest visitors and be useful to the staff. Within the application, a user who is not logged in can view the current number of available tables, the restaurant's phone number, and access the food and drink menu. Staff members need to be logged in for their needs and have additional options depending on their role, which can be a waiter, chef, or administrator.

The waiter can reserve and add orders for a specific table, add food or drink items from the menu, and receive feedback if the table is occupied. Food orders entered by the waiter are automatically forwarded for display to the chef.

The chef's role allows marking completed orders and automatically adding the marked orders to the list of completed meals, which can be accessed by users in the waiter and chef roles. Additionally, the waiter has the function to free up a table and delete table orders.

The administrator role allows adding, editing, and deleting employee user accounts from the database, and has the option to view and use all the functionalities implemented for other roles.

<div style="text-align: center;">
<img src="https://github.com/user-attachments/assets/efdf2830-4ace-4b03-9e77-09b9d76ba9e1" width="400"/> <img src="https://github.com/user-attachments/assets/6fe3a1dc-00b0-47ba-b630-1cbdcf7446ee" width="270"/>

<img src="https://github.com/user-attachments/assets/5a899b88-24d9-4145-91d2-b43982883c7a" width="400"/> <img src="https://github.com/user-attachments/assets/6c373398-49c7-4f71-91a8-3d2ce047220f" width="400"/>

 <img src="https://github.com/user-attachments/assets/baa9db5a-e732-4d3b-964d-15941af85472" width="400"/> <img src="https://github.com/user-attachments/assets/1cd9bdbb-f9e8-4358-b786-5c09f277c50b" width="400"/>

</div>







Link: https://dabar.srce.hr/islandora/object/infri:1083
