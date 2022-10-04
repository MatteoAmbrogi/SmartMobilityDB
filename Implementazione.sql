-- IMPLEMENTAZIONE 

SET GLOBAL event_scheduler = ON;

DROP DATABASE IF EXISTS Progetto_BasiDiDati;
CREATE DATABASE Progetto_BasiDiDati;
USE Progetto_BasiDiDati;

-- CREATE TABLE 

CREATE TABLE Utente (	
	codFiscale varchar(255) not null,
	nome varchar(255) not null,
	cognome varchar(255) not null,
	numeroTelefono varchar(255) not null,
	stato varchar(255) default "inattivo",
	PRIMARY KEY (codFiscale)
);
CREATE TABLE Iscrizione (
	codFiscale varchar(255) not null,
	dataIscrizione Date,
	tipoDocumento varchar(255) not null,
	numeroDocumento int not null,
	scadenza Date not null,
	enteRilascio varchar(255) not null,
	PRIMARY KEY (codFiscale),
	FOREIGN KEY (codFiscale)
	REFERENCES Utente (codFiscale)
);
CREATE TABLE Indirizzo (
	codFiscale varchar(255) not null,
	via varchar(255) not null,
	numeroCivico int not null, 
	comune varchar(255) not null,
	regione varchar(255) not null,
	cap int not null,
	provincia varchar(255) not null,
	PRIMARY KEY (codFiscale),
	FOREIGN KEY (codFiscale)
	REFERENCES Utente (codFiscale)
);
CREATE TABLE Account (
	nomeUtente varchar(255) not null,
	password varchar(255) not null,
	domanda text,
	risposta text,
	codFiscale varchar(255) not null,
	numeroValutazioni int default 0,
	sommaValPersona int default 0,
	sommaValComportamento int default 0,
	sommaValSerieta int default 0,
	PRIMARY KEY (nomeUtente),
	FOREIGN KEY (codFiscale)
	REFERENCES Utente (codFiscale)
);
CREATE TABLE Ruolo (
	codAccount varchar(255) not null,
	ruolo varchar(255) not null,
	PRIMARY KEY (codAccount, ruolo),
	FOREIGN KEY (codAccount)
	REFERENCES Account (nomeUtente)
);
CREATE TABLE Carburante (
	nome varchar(255) not null,
	costo double not null,
	PRIMARY KEY (nome)
);

CREATE TABLE Modello (
	codModello int not null auto_increment,
	casaProduttrice varchar(255) not null,
	nomeModello varchar(255) not null,
	cilindrata double not null,
	numPosti int not null,
	dimensioneBagaglio double not null,
	ruomoreMedio double not null,
	tipoCarburante varchar(255) not null,
	capacitàSerbatoio double not null,
	velocitàMassima double not null,
	consumoUrbano double not null,
	consumoExtraurbano double not null,
	costoOperativo double not null,
	costoUsura double not null,
	costoOperativoEUsuraPerPersona double not null,
	PRIMARY KEY (codModello),
	FOREIGN KEY (tipoCarburante)
	REFERENCES Carburante(nome)
);

CREATE TABLE Autovettura (
	targa varchar(255) not null,
	codAccountProprietario varchar(255) not null,
	annoImmatricolazione int not null,
	codModello int  not null,
	totKmPercorsi int not null,
	totCarburante double not null,
	livelloDiComfort int not null,
	PRIMARY KEY (targa),
	FOREIGN KEY (codAccountProprietario)
	REFERENCES Account(nomeUtente),
	FOREIGN KEY (codModello)
	REFERENCES Modello(codModello)
);
CREATE TABLE Optional (
	codice int not null auto_increment,
	nome varchar(255) not null,
	PRIMARY KEY (codice)
);

CREATE TABLE Possedere (
	targa varchar(255) not null,
	codOptional int not null,
	PRIMARY KEY (targa, codOptional),
	FOREIGN KEY (targa)
	REFERENCES Autovettura(targa),
	FOREIGN KEY (codOptional)
	REFERENCES Optional(codice)
);
CREATE TABLE Autovettura_Car_Sharing (
	targa varchar(255) not null,
	disponibilità varchar(255) not null,
	numSharingPrecedenti int not null default 0,
	PRIMARY KEY(Targa),
	FOREIGN KEY (targa)
	REFERENCES Autovettura(targa)
);
CREATE TABLE Giorno_E_Orario (
	targa varchar(255) not null,
	giorno varchar(255) not null,
	oraInizio time not null,
	oraFine time not null,
	PRIMARY KEY(targa, giorno, oraInizio, oraFine),
	FOREIGN KEY(targa)
	REFERENCES Autovettura(targa)
);


CREATE TABLE Strada (
	codice int not null auto_increment,
	tipologia varchar(255),
	numeroTipologia int,
	categorizzazione varchar(255),
	suffisso varchar(255),
	nome varchar(255),
	lunghezza int,
	numCarreggiate int,
	numCorsieCarreggiata int,
	numSensiDiMarcia int,
	classificazioneTecnica varchar(255),
	PRIMARY KEY(codice)
);
CREATE TABLE Chilometro (
	codStrada int not null, 
	numKm int not null,
	latitudine double not null,
	longitudine double not null,
	tempoPercorrenza int not null,
	limite int not null,
	PRIMARY KEY (codStrada, numKm),
	FOREIGN KEY (codStrada)
	REFERENCES Strada(codice)
);
CREATE TABLE Incrocio (
	codStrada1 int not null,
	codStrada2 int not null,
	numKm1 int not null,
	numKm2 int not null,
	PRIMARY KEY (codStrada1, codStrada2, numKm1, numKm2),
	FOREIGN KEY (codStrada1, numKm1)
	REFERENCES Chilometro(codStrada, numKm),
	FOREIGN KEY (codStrada2, numKm2)
	REFERENCES Chilometro(codStrada, numKm)
);
CREATE TABLE DoppioNome (
	numeroTipologia int not null,
	codStrada int not null,
	PRIMARY KEY (numeroTipologia),
	FOREIGN KEY (codStrada)
	REFERENCES Strada(codice)
);
CREATE TABLE Pedaggio (
	codStrada int not null,
	km int not null,
	costo double not null,
	PRIMARY KEY (codStrada, km),
	FOREIGN KEY (codStrada, km)
	REFERENCES Chilometro(codStrada, numKm)
);
CREATE TABLE Tragitto (
	codice int not null auto_increment,
	daStradaInizio int not null,
	daKmInizio int not null,
	aStradaFine int not null,
	aKmFine int not null,
	PRIMARY KEY (codice),
	FOREIGN KEY(daStradaInizio, daKmInizio)
	REFERENCES Chilometro(codStrada, numKm),
FOREIGN KEY (aStradaFine, aKmFine)
	REFERENCES Chilometro(codStrada, numKm)
);
CREATE TABLE Prenotazione_Di_Noleggio (
	codice int not null auto_increment,
	utenteFruitore varchar(255) not null,
	targa varchar(255) not null,
	dataInizio date not null,
	dataFine date not null,
	oraInizio time not null,
	oraFine time,
	accettata varchar(255),
	codTragitto int not null,
	totCarburante double ,
	PRIMARY KEY(codice),
	FOREIGN KEY (utenteFruitore)
	REFERENCES Account(nomeUtente),
	FOREIGN KEY (targa)
	REFERENCES Autovettura(targa),
	FOREIGN KEY (codTragitto)
	REFERENCES Tragitto(codice)
);
CREATE TABLE Tracking (
	targa varchar(255) not null,
	codStrada int not null,
	numKm int not null,
	timeStamp timestamp not null,
	PRIMARY KEY (targa, timeStamp),
	FOREIGN KEY (targa)
	REFERENCES Autovettura(targa),
	FOREIGN KEY (codStrada, numKm)
	REFERENCES Chilometro(codStrada, numKm) 
);

CREATE TABLE Sinistro (
	codSinistro int not null auto_increment,
	orario time not null,
	codStrada int not null,
	numKm int not null,
	codNoleggio int not null,
	dinamica varchar(255) not null,
	PRIMARY KEY (codSinistro),
	FOREIGN KEY (codStrada, numKm)
	REFERENCES  chilometro(codStrada,numKm),
	FOREIGN KEY (codNoleggio)
	REFERENCES  Prenotazione_Di_Noleggio(codice)
);

CREATE TABLE Auto_Coinvolte (
	codSinistro int not null,
	modello varchar(255) not null,
	targa varchar(255) not null,
	casaAutomobilistica varchar(255) not null, 
	PRIMARY KEY (codSinistro,targa),
	FOREIGN KEY (codSinistro)
	REFERENCES  Sinistro(codSinistro)
);

CREATE TABLE Pool (
	codPool int not null auto_increment,
	targa varchar(255) not null,
	dataPartenza date not null,
	dataArrivo date not null,
	oraPartenza time not null,
	oraArrivo time not null,
	flessibilita varchar(255) not null,
	periodoValidita int not null,
	costoPercVar double not null,
	codTragitto int not null,
	PRIMARY KEY (codPool),
	FOREIGN KEY (targa)
	REFERENCES  Autovettura(targa),
	FOREIGN KEY (codTragitto)
	REFERENCES  Tragitto(codice)
);

CREATE TABLE Composto (
	codice int not null auto_increment,
	codStrada int not null,
	numKm int not null,
	codTragitto int not null,
	PRIMARY KEY (codice),
	FOREIGN KEY (codStrada,numKm)
	REFERENCES  Chilometro(codStrada,numKm),
	FOREIGN KEY (codTragitto)
	REFERENCES  Tragitto(codice)
);

CREATE TABLE Prenotazione_Di_Pool (
	codPrenotazione int not null auto_increment,
	accountFruitore varchar(255) not null,
	codPool int not null,
	codStradaInizio int not null,
	kmInizio int not null,
	codStradaFine int not null,
	kmFine int not null,
	codVariazione int, 
	accettataVariazione int, -- null,1
	accettataPrenotazione int, -- null,1
	PRIMARY KEY (codPrenotazione),
	FOREIGN KEY (accountFruitore)
	REFERENCES  Account(nomeUtente),
	FOREIGN KEY (codPool)
	REFERENCES  Pool(codPool),
	FOREIGN KEY (codStradaInizio,kmInizio)
	REFERENCES  Chilometro(codStrada,numKm),
	FOREIGN KEY (codStradaFine, kmFine)
	REFERENCES  Chilometro(codStrada,numKm),
	FOREIGN KEY (codVariazione)
	REFERENCES  Tragitto(codice)
);

CREATE TABLE Ride_Sharing (
	codSharing int not null auto_increment,
	targa varchar(255) not null,
	codTragitto int not null,
	oraPartenza time not null,
	giornoPartenza date not null,
	costoAlChilometro int not null,
	utenteProponente varchar(255) not null,
	PRIMARY KEY (codSharing),
	FOREIGN KEY (targa)
	REFERENCES  Autovettura(targa),
	FOREIGN KEY (codTragitto)
	REFERENCES  Tragitto(codice),
	FOREIGN KEY (utenteProponente)
	REFERENCES  Account(nomeUtente)
);

CREATE TABLE Chiamata (
	codChiamata int not null auto_increment,
	accountFruitore varchar(255) not null,
	codSharing int not null,
	kmInizio int not null,
	codStradaInizio int not null,
	kmFine int not null,
	codStradaFine int not null,
	timeStamp timestamp not null default current_timestamp(),
	stato varchar(255) not null default "Pending" , 
	timeStampRisposta timestamp not null,
	PRIMARY KEY (codChiamata),
	FOREIGN KEY (accountFruitore)
	REFERENCES  Account(nomeUtente),
	FOREIGN KEY (codSharing)
	REFERENCES  Ride_Sharing(codSharing),
	FOREIGN KEY (codStradaInizio,kmInizio)
	REFERENCES  Chilometro(codStrada,numKm),
	FOREIGN KEY (codStradaFine,kmFine)
	REFERENCES  Chilometro(codStrada,numKm)
);

CREATE TABLE Corsa (
	codChiamata int not null,
	timeStampInizio timestamp not null,
	timeStampFine timestamp,
	PRIMARY KEY (codChiamata,timeStampInizio),
	FOREIGN KEY (codChiamata)
	REFERENCES  Chiamata(codChiamata)
);

CREATE TABLE Valutazione (
	codValutazione int not null auto_increment,
	codTragitto int not null,
	accountRiceve varchar(255) not null,
	ruoloRiceve varchar(255) not null,
	accountScrive varchar(255) not null,
	valPersona int not null,
	valComportamento int not null,
	valSerieta int not null,
	recensione varchar(255) not null,
	PRIMARY KEY (codValutazione),
	FOREIGN KEY (codTragitto)
	REFERENCES  Tragitto(codice),
	FOREIGN KEY (accountRiceve)
	REFERENCES  Account(nomeUtente),
	FOREIGN KEY (accountScrive)
	REFERENCES  Account(nomeUtente)
);

CREATE TABLE Valutazione_Guida (
	codValutazione int not null,
	valPiacereViaggio int not null,
	PRIMARY KEY (codValutazione),
	FOREIGN KEY (codValutazione)
	REFERENCES  Valutazione(codValutazione)
);

-- LOG TABLE

CREATE TABLE valutazioni_log 
(
	codValutazione int not null,
	account varchar(255) not null,
	ruolo varchar(255) not null,
	valPersona int not null,
	valComportamento int not null,
	valSerieta int not null,
	PRIMARY KEY (codValutazione)
);

CREATE TABLE valutazioni_guida_log 
(
	codValutazione int not null,
	valPiacereViaggio int not null,
	PRIMARY KEY (codValutazione)
);

CREATE TABLE tracking_log LIKE tracking;

-- MATERIALIZED VIEW

CREATE TABLE MV_affidabilita_utenti
(
	account varchar(255) not null,
	ruolo varchar(255) not null,
	numeroValutazioni int not null,
	sommaMedie double not null, 
	PRIMARY KEY (account,ruolo)
);

CREATE TABLE MV_criticità_strade
(
	codStrada int not null,
    numKm int not null,
    timeStampRilevamento timestamp not null,
    primary key(codStrada,numKm,timeStampRilevamento)
);


-- VINCOLI DI INTEGRITÀ GENERICI


-- TR01
drop trigger if exists Insert_Utente;

delimiter $$

create trigger Insert_Utente
before insert on Utente
for each row
begin
	if (new.stato <> 'attivo' and new.stato <> 'inattivo') then
		signal sqlstate '45000'
		set message_text = 'Valore dello stato errato';
	end if;
end $$
delimiter ;



-- TR02
drop trigger if exists Insert_Iscrizione;

delimiter $$

create trigger Insert_Iscrizione
before insert on Iscrizione
for each row
begin
	if (new.scadenza < new.dataIscrizione) then
		signal sqlstate '45000'
		set message_text = 'Errore: data di iscrizione maggiore o uguale alla data di scadenza del documento!';
	end if;
end $$
delimiter ;



-- TR03
drop trigger if exists Insert_Ruolo;

delimiter $$

create trigger Insert_Ruolo
before insert on Ruolo
for each row
begin
	if (new.ruolo <> 'proponente' and new.ruolo <> 'fruitore') then
		signal sqlstate '45000'
		set message_text = 'Valore non permesso per il ruolo';
	end if;
end $$
delimiter ;



-- TR04
drop trigger if exists 	Insert_Account;

delimiter $$

create trigger Insert_Account
before insert on Account
for each row
begin
	declare stato varchar(100) default '';
	
-- cerco lo stato di quell’utente
	Select U.stato into stato
	From Utente U
	Where U.codFiscale = new.codFiscale;
	
	if (stato = 'inattivo') then
		signal sqlstate '45000'
		set message_text = 'Non può essere creato l’account!';
	end if;
end $$
delimiter ;



-- TR05
drop trigger if exists Insert_Indirizzo;

delimiter $$

create trigger Insert_Indirizzo
before insert on Indirizzo
for each row
begin
	
    if new.numeroCivico <= 0 then
		signal sqlstate '45000'
		set message_text = 'Valore del numero civico errato';
	end if;
end $$
delimiter ;



-- TR06
drop trigger if exists Insert_Autovettura;

delimiter $$

create trigger Insert_Autovettura
before insert on Autovettura
for each row
begin
	
    declare quantoSerbatoio double default 0;
	
	-- cerco quanto serbatoio ha quel modello
	Select M.capacitàSerbatoio into quantoSerbatoio
	From Modello M
	Where 	M.codModello = new.codModello;

	if (new.annoImmatricolazione > year(current_date)) then
		signal sqlstate '45000'
		set message_text = 'Anno di immatricolazione errato';
	elseif (new.livelloDiComfort < 1 or new.livelloDiComfort > 5) then
		signal sqlstate '45000'
		set message_text = 'Valore di comfort errato';
	elseif (new.totCarburante < 0 or new.totCarburante > quantoSerbatoio) then
		signal sqlstate '45000'
		set message_text = 'Quantità di carburante errata';
	end if;
end $$
delimiter ;



-- TR07
drop trigger if exists Insert_Modello;

delimiter $$

create trigger Insert_Modello
before insert on Modello
for each row
begin
	if (new.numPosti < 1) then
		signal sqlstate '45000'
		set message_text = 'Un’autovettura deve avere almeno un posto!';
	end if;
end $$
delimiter ;



-- TR08
drop trigger if exists Insert_Carburante;

delimiter $$

create trigger Insert_Carburante
before insert on carburante
for each row
begin
	if (new.costo < 0) then
		signal sqlstate '45000'
		set message_text = 'Costo del carburante errato';
	end if;
end $$
delimiter ;



-- TR09
drop trigger if exists Insert_Autovettura_Car_Sharing;

delimiter $$

create trigger Insert_Autovettura_Car_Sharing
before insert on Autovettura_Car_Sharing
for each row
begin
	if (new.disponibilità <> 'disponibile' and new.disponibilità <> 'noleggiata') then
		signal sqlstate '45000'
		set message_text = 'Valore della disponibilità errato';
	end if;
end $$
delimiter ;



-- TR10
drop trigger if exists Insert_Giorno_E_Orario;

delimiter $$

create trigger Insert_Giorno_E_Orario
before insert on Giorno_E_Orario
for each row
begin
	if (new.oraInizio > new.oraFine) then
		signal sqlstate '45000'
		set message_text = 'Valori delle ore errati';
	elseif (new.giorno <> 'lun' and new.giorno <> 'mar' and new.giorno <> 'mer' and new.giorno <> 'gio' and new.giorno <> 'ven' and new.giorno <> 'sab' and new.giorno <> 'dom') then
		signal sqlstate '45000'
		set message_text = 'Valori del giorno errato';
	end if;
end $$
delimiter ;



-- TR11
drop trigger if exists Insert_Prenotazione_Di_Noleggio;

delimiter $$

create trigger Insert_Prenotazione_Di_Noleggio
before insert on Prenotazione_Di_Noleggio
for each row
begin
	if (new.dataInizio > new.dataFine) then
		signal sqlstate '45000'
		set message_text = 'Valori delle date errati';
	elseif (new.oraInizio > new.oraFine) then
		signal sqlstate '45000'
		set message_text = 'Valori delle ore errati';
	elseif (new.accettata <> 'si' and new.accettata <> 'no' and new.accettata is not null) then
		signal sqlstate '45000'
		set message_text = 'Valore dell’attributo accettata errato';
	end if;
end $$
delimiter ;



-- TR12
drop trigger if exists Insert_Strada;

delimiter $$

create trigger Insert_Strada
before insert on Strada
for each row
begin
	if (new.tipologia <> 'ss' and new.tipologia <> 'sr' and new.tipologia <> 'sp' and new.tipologia <> 'sc' and new.tipologia <> 'sv' and new.tipologia is not null) then
		signal sqlstate '45000'
		set message_text = 'Tipologia errata';
	elseif (new.categorizzazione <> 'dir' and new.categorizzazione <> 'var' and new.categorizzazione <> 'racc' and new.categorizzazione <> 'radd' 
				and new.categorizzazione is not null) then
		signal sqlstate '45000'
		set message_text = 'Valore della categorizzazione errato';
	elseif (new.suffisso <> 'bis' and new.suffisso <> 'ter' and new.suffisso <> 'quater' and new.suffisso is not null) then
		signal sqlstate '45000'
		set message_text = 'Valore del suffisso errato';
	elseif (new.categorizzazione is not null and new.suffisso is not null) then
		signal sqlstate '45000'
		set message_text = 'Non si può definire sia la categorizzazione che il suffisso';
	elseif (new.classificazioneTecnica <> 'a' and new.classificazioneTecnica <> 'u' and new.classificazioneTecnica <> 'es' and new.classificazioneTecnica <> 'ep' 
				and new.classificazioneTecnica is not null) then
		signal sqlstate '45000'
		set message_text = 'Classificazione tecnica errata';
	end if;
end $$
delimiter ;



-- TR13
drop trigger if exists Insert_Pool;

delimiter $$
create trigger Insert_Pool 
before insert on pool
for each row
begin
	
    if new.periodoValidita < 48 and (
									new.flessibilita <> 'Nessuna'
                                    or
									new.flessibilita <> 'Basso'
                                    or
									new.flessibilita <> 'Medio'
                                    or
                                    new.flessibilita <> 'Alto'
									)
	then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento del pool';
	end if;
     
    
    if 
		new.dataPartenza > new.dataArrivo
        or
        (
			new.dataPartenza = new.dataArrivo
            and 
            new.oraPartenza > new.oraArrivo
		)
    then 
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento delle date del pool';
    end if;
    
    
end$$
delimiter ;



-- TR14
drop trigger if exists Insert_Prenotazione_Di_Pool;

delimiter $$

create trigger Insert_Prenotazione_Di_Pool
before insert on prenotazione_di_pool
for each row
begin
	
    if new.accettataPrenotazione=1 and new.codVariazione is not null and new.accettataVariazione is null
    then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della prenotazione di pool';
	end if;
    
    
end$$
delimiter ;



-- TR15
drop trigger if exists Insert_Chiamata;

delimiter $$

create trigger Insert_Chiamata
before insert on chiamata
for each row
begin
	
    if 
		(
			new.stato <> 'Pending'
            and
            new.stato <> 'Rejected'
            and
            new.stato <> 'Accepted'
        )
	then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Chiamata';
    end if;
    
end$$
delimiter ;



-- TR16
drop trigger if exists Insert_Corsa;

delimiter $$

create trigger Insert_Corsa
before insert on corsa
for each row
begin
	
    declare statoChiamata varchar(255) default '';
    
    select c.stato into statoChiamata
    from
		chiamata c
	where
        c.codChiamata=new.codChiamata;
        
	if statoChiamata <> 'Accepted' then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Corsa';
	end if;
    
end$$
delimiter ;



-- TR17
drop trigger if exists Insert_Valutazione;

delimiter $$

create trigger Insert_Valutazione
before insert on valutazione
for each row
begin
	declare check_ruolo int default 0;
	
    if new.accountRiceve = new.accountScrive then 
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Valutazione';
	end if;
    
    if 	new.valComportamento > 5 or new.valComportamento < 1
		or
        new.valPersona > 5 or new.valPersona < 1
        or
        new.valSerieta > 5 or new.valSerieta < 1
	then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Valutazione';
	end if;
    
	if (new.ruoloRiceve <> 'proponente' and new.ruoloRiceve <> 'fruitore' )
	then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Valutazione, quel ruolo non esiste!';
	end if;
	
	select count(*) into check_ruolo
	from ruolo R
	where R.codAccount = new.accountRiceve
	and R.ruolo = new.ruoloRiceve;
	
	if (check_ruolo = 0) -- allora quell'utente non può avere quel ruolo
	then
		signal sqlstate '45000'
        set message_text = 'Attenzione, l’utente a cui è indirizzata questa valutazione non può avere quel ruolo!';
	end if;
    
end$$
delimiter ;



-- TR18
drop trigger if exists Insert_Valutazione_Guida;

delimiter $$

create trigger Insert_Valutazione_Guida
before insert on valutazione_guida
for each row
begin
	
    if new.valPiacereViaggio > 5 or new.valPiacereViaggio < 1 then
		signal sqlstate '45000'
        set message_text = 'Errore nell’ inserimento della Valutazione';
	end if;
    
end$$
delimiter ;



-- TRIGGER PER LE RIDONDANZE

drop trigger if exists ridondanza_account;

delimiter $$

create trigger ridondanza_account
after insert on valutazione
for each row
begin
	update account
    set numeroValutazioni = numeroValutazioni + 1, 
		sommaValPersona = sommaValPersona + new.valPersona,
		sommaValComportamento = sommaValComportamento + new.valComportamento,
        sommaValSerieta = sommaValSerieta + new.valSerieta
    where nomeUtente = new.accountRiceve;
end $$
delimiter ;



-- trigger per la torretta del car sharing e per l'aggiornamento della ridondanza

drop trigger if exists torretta_car_sharing;

delimiter $$

create trigger torretta_car_sharing
before update on prenotazione_di_noleggio
for each row
begin
	
    declare vecchioCarb double default 0;
    
    select a.totCarburante into vecchioCarb
	from
		autovettura a
	where
		new.targa = a.targa;
    
    
    if (new.totCarburante >= (vecchioCarb * 0.9)) then
		begin
			update autovettura
			set totCarburante = new.totCarburante
			where targa = new.targa;

			update autovettura_car_sharing
			set numSharingPrecedenti = numSharingPrecedenti + 1
			where targa = new.targa;
        end;
	else
		signal sqlstate '45000'
        set message_text = 'Carburante non sufficiente';
	end if;
    
end$$
delimiter ;


-- trigger per inserire nelle log table

drop trigger if exists push_valutazioni_log;

delimiter $$

create trigger push_valutazioni_log
after insert on Valutazione
for each row
begin
	insert into valutazioni_log
	values (new.codValutazione, new.accountRiceve, new.ruoloRiceve, new.valPersona, new.valComportamento, new.valSerieta
	);
end $$
delimiter ;


drop trigger if exists push_valutazioni_guida_log;

delimiter $$

create trigger push_valutazioni_guida_log
after insert on Valutazione_Guida
for each row
begin
	insert into valutazioni_guida_log
	values (new.codValutazione, new.valPiacereViaggio
	);
end $$
delimiter ;
 

drop trigger if exists push_tracking_log;

delimiter $$

create trigger push_tracking_log
after insert on tracking
for each row
begin
	insert into tracking_log
    values (new.targa , new.codStrada , new.numKm , new.timeStamp );
end$$

delimiter ;





-- LE 8 OPERAZIONI

-- prima operazione 

drop procedure if exists nuovo_utente;

delimiter $$

create procedure nuovo_utente (
	IN _codFiscale varchar(255),
    IN _nome varchar(255),
    IN _cognome varchar(255),
    IN _telefono varchar(255),
    IN _via varchar(255),
    IN _numeroCivico int,
    IN _comune varchar(255),
    IN _regione varchar(255),
    IN _cap int,
    IN _provincia varchar(255),
    IN _tipoDiDocumento varchar(255),
    IN _scadenza date,
    IN _enteRilascio varchar(255),
    iN _numeroDocumento int,
    IN _nomeUtente varchar(255),
    IN _password varchar(255),
    IN _domanda text,
    IN _risposta text,
    IN _ruolo int -- 1 se proponente, 0 se fruitore, 2 se sia proponente che fruitore
)
begin
	insert into utente 
	values (_codFiscale, _nome, _cognome, _telefono, 'attivo');
    
    insert into iscrizione
    values (_codFiscale, current_date(), _tipoDiDocumento, _numeroDocumento, _scadenza, _enteRilascio);
    
    insert into indirizzo
    values (_codFiscale, _via, _numeroCivico, _comune, _regione, _cap, _provincia);
    
    insert into account
    values (_nomeUtente, _password, _domanda, _risposta, _codFiscale, 0, 0, 0, 0);
    
    if (_ruolo = 0) then
		insert into ruolo
        values (_nomeUtente, 'fruitore');
	elseif (_ruolo = 1) then
		insert into ruolo
        values (_nomeUtente, 'proponente');
	elseif (_ruolo = 2) then
		insert into ruolo
        values (_nomeUtente, 'proponente');
		insert into ruolo
        values (_nomeUtente, 'fruitore');
    end if ;
end $$






-- seconda operazione

drop procedure if exists calcolo_spesa_car_pooling;

delimiter $$

create procedure calcolo_spesa_car_pooling
(
	IN _codPrenotazione int,
    OUT spesa_ double
)
begin
	declare accettata_prenotazione int default 1;

    declare codice_inizio int default 0; -- numero da dove ha iniziato a far parte del pool
    declare codice_fine int default 0; -- numero dove ha finito
    declare codice_strada_inizio int default 0;
    declare codice_strada_fine int default 0;
    declare km_inizio int default 0;
    declare km_fine int default 0;
    
    declare cod_pool int default 0;
    declare quante_prenotazioni int default 0;
    
    declare targa varchar(255) default '';
    declare cod_modello int default 0;
    
    declare consumo_urbano double default 0; -- ogni km consuma tot litri
    declare consumo_extra_urbano double default 0;
    declare costo_operativo double default 0; -- ogni km
    declare costo_usura double default 0; -- ogni km
    declare costo_operativo_e_usura_per_persona double default 0; -- ogni km
    declare tipo_carburante varchar(255) default 0;
    
    declare costo_al_litro double default 0;
    
    declare cod_tragitto int default 0;
    
    declare spesa_carburante double default 0;
    declare spesa_pedaggio double default 0;
    declare quanti_km int default 0; -- totali
    declare quanti_km_urbani int default 0;
    declare quanti_km_extra_urbani int default 0;
    declare spesa_altre double default 0; -- spesa per costi operativi, ecc
    declare spesa_tragitto double default 0; -- spesa parte in comune

	declare costo_perc_variazione double default 0;	
    declare accettata_variazione int default 1; -- di default c'è variazione
	
	-- prelevo le informazioni inerenti a dove è partito l'utente e dove è sceso (parti in comune)
    select P.codStradaInizio, P.codStradaFine, P.kmInizio, P.kmFine, P.codPool, P.accettataVariazione, P.accettataPrenotazione
		into codice_strada_inizio, codice_strada_fine, km_inizio, km_fine, cod_pool, accettata_variazione, accettata_prenotazione
    from prenotazione_di_pool P
    where P.codPrenotazione = _codPrenotazione;
    
    if (accettata_prenotazione = NULL) then
		signal sqlstate '45000'
        set message_text = 'Questa prenotazione non è stata accettata, quindi l\'utente non ha preso parte al pool';
	end if;
    
    -- quante prenotazioni per quel pool, compreso se stesso
    select count(*) into quante_prenotazioni
    from prenotazione_di_pool P
    where P.codPool = cod_pool
    and P.accettataPrenotazione = 1; -- è stata accettata
    
    select P.targa, P.codTragitto, P.costoPercVar into targa, cod_tragitto, costo_perc_variazione
    from pool P
    where P.codPool = cod_pool;
    
    select A.codModello into cod_modello
    from autovettura A
    where A.targa = targa;
	
	 -- prelevo le informazioni sui consumi dell'autovettura
    select M.consumoUrbano, M.consumoExtraurbano, M.costoOperativo, M.costoUsura, M.costoOperativoEUsuraPerPersona, M.tipoCarburante
		into consumo_urbano, consumo_extra_urbano, costo_operativo, costo_usura, costo_operativo_e_usura_per_persona, tipo_carburante
    from modello M
    where M.codModello = cod_modello;
    
    -- prelevo le informazioni sul costo del carburante
    select C.costo into costo_al_litro
    from carburante C
    where C.nome = tipo_carburante;
    
    -- cerco il codice di composto nel quale è partito
    select C.codice into codice_inizio
    from composto C
    where C.codTragitto = cod_tragitto
    and C.codStrada = codice_strada_inizio
    and C.numKm = km_inizio;
    
    -- cerco il codice di composto nel quale è sceso
    select C.codice into codice_fine
    from composto C
    where C.codTragitto = cod_tragitto
    and C.codStrada = codice_strada_fine
    and C.numKm = km_fine;
    
    
	-- km percorsi del tragitto da parte dell'utente (esclusa la variazione)
    CREATE TEMPORARY TABLE IF NOT EXISTS km_percorsi_utente
    (
		codice int not null,
        codStrada int not null,
        numKm int not null,
        primary key (codice) -- rimane univoco anche nel sottoinsieme
    ) engine = innoDB default charset=latin1;
    
    truncate table km_percorsi_utente;
    
    insert into km_percorsi_utente
    select Comp.codice, Comp.codStrada, Comp.numKm
    from composto Comp
    where Comp.codice >= codice_inizio
    and Comp.codice <= codice_fine;
    
	select count(*) into quanti_km
    from km_percorsi_utente K;
    
    select count(*) into quanti_km_urbani
    from km_percorsi_utente K inner join strada S on S.codice = K.codStrada
    where S.classificazioneTecnica = 'u';
    
	select count(*) into quanti_km_extra_urbani
    from km_percorsi_utente K inner join strada S on S.codice = K.codStrada
    where S.classificazioneTecnica = 'es'
    or S.classificazioneTecnica = 'ep';
    
    set spesa_carburante = (quanti_km_urbani * consumo_urbano * costo_al_litro) 
		+ (quanti_km_extra_urbani * consumo_extra_urbano * costo_al_litro);
    
    select sum(P.costo) into spesa_pedaggio -- spesa in euro
    from km_percorsi_utente K inner join pedaggio P 
		on K.codStrada = P.codStrada and K.numKm = P.km;
    
    set spesa_altre = quanti_km * (costo_operativo + costo_usura + (costo_operativo_e_usura_per_persona*quante_prenotazioni));

    
    if (spesa_pedaggio is not null) then
		-- + 1 perchè c'è anche il proponente che paga la sua parte
		set spesa_tragitto = (spesa_carburante + spesa_altre + spesa_pedaggio) / (quante_prenotazioni + 1);
	else
		set spesa_tragitto = (spesa_carburante + spesa_altre) / (quante_prenotazioni + 1);
    end if;
    
    set spesa_ = spesa_tragitto;
    
    if (accettata_variazione = 1) then -- c'è stata variazione
		set spesa_ = (spesa_/100) * (100+costo_perc_variazione);
    end if;
    
    set spesa_ = round(spesa_,2);
end $$





-- terza operazione
drop procedure if exists spesa_ride_sharing;

delimiter $$

create procedure spesa_ride_sharing (
									in _codChiamata int,
                                    out spesa_ double
									)
begin
	
    declare errore int default 0;
    
	declare kmInizio int default 0;
    declare kmFine int default 0;
    declare stradaInizio int default 0;
    declare stradaFine int default 0;
    
    declare costoKm int default 0;
    declare tragitto int default 0;
    declare codSharing int default 0;
    
	declare codInizio int default 0;
	declare codFine int default 0;
    
    declare quantiKm int default 0;
    
    
    select count(*) into errore
	from
		corsa co
	where
		co.codChiamata = _codChiamata
    ;
    
    if errore = 0 then
		signal sqlstate '45000'
        set message_text = 'Errore in inserimento del codice';
    end if;
    
    
    
    select ch.kmInizio,ch.codStradaInizio,ch.kmFine,ch.codStradaFine,ch.codSharing into kmInizio,stradaInizio,kmFine,stradaFine,codSharing
	from
		chiamata ch
	where
		ch.codChiamata = _codChiamata;
    
    
    
    
	select rs.codTragitto,rs.costoAlChilometro into tragitto,costoKm
	from
		ride_sharing rs
	where
		rs.codSharing = codSharing;
        
	
    
    
    select c.codice into codInizio
	from
        composto c
	where
		c.codTragitto = tragitto
        and
        c.codStrada = stradaInizio
        and
        c.numKm = kmInizio;
       
       
       
       
       
	select c.codice into codFine
	from
        composto c
	where
		c.codTragitto = tragitto
        and
        c.codStrada = stradaFine
        and
        c.numKm = kmFine;
        
        
        
	select count(*) into quantiKm
    from
		composto c
	where
		c.codTragitto = tragitto
        and
        c.codice >= codInizio
        and
        c.codice <= codFine;
	
    
    set spesa_ = (quantiKm * costoKm ) ;
	
    
end$$
delimiter ;





-- quarta operazione

drop procedure if exists valutazione_al_proponente_pool;

delimiter $$

create procedure valutazione_al_proponente_pool
(
	IN _codPrenotazione int,
    IN _valPersona int,
    IN _valComportamento int,
    IN _valSerieta int,
    IN _recensione varchar(255),
    IN _valPiacereViaggio int
)
begin
	declare account_fruitore varchar(255) default '';
    declare cod_pool int default 0;
    declare cod_tragitto int default 0;
    declare targa_auto varchar(255) default '';
    declare nome_utente_proponente varchar(255) default '';
    declare cod_valutazione int default 0;
    
    select P.accountFruitore, P.codPool into account_fruitore, cod_pool
    from prenotazione_di_pool P
    where P.codPrenotazione = _codPrenotazione;
    
    select P.codTragitto, P.targa into cod_tragitto, targa_auto
    from pool P
    where P.codPool = cod_pool;
    
    select A.codAccountProprietario into nome_utente_proponente
    from autovettura A
    where A.targa = targa_auto;
    
    insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
	values (cod_tragitto, nome_utente_proponente, 'proponente', account_fruitore, _valPersona, _valComportamento, _valSerieta, _recensione
	);
    
    select V.codValutazione into cod_valutazione
    from valutazione V
    order by V.codValutazione DESC
    limit 1;
    
    insert into valutazione_guida
    values (cod_valutazione, _valPiacereViaggio
    );
    
end $$






-- quinta operazione

drop procedure if exists valutazione_al_proponente_ride_sharing;

delimiter $$

create procedure valutazione_al_proponente_ride_sharing
(
	IN _codChiamata int,
    IN _valPersona int,
    IN _valComportamento int,
    IN _valSerieta int,
    IN _valPiacereViaggio int,
    IN _recensione varchar(255)
)
begin
	declare presente int default 0; -- controllo se la chiamata ha fattivamente portato ad una corsa
    declare nome_utente_fruitore varchar(255) default '';
    declare cod_sharing int default 0;
    declare tragitto int default 0;
    declare targa varchar(255) default '';
    declare nome_utente_proponente varchar(255) default '';
    declare cod_valutazione int default 0;
    
    select count(*) into presente
    from corsa C
    where C.codChiamata = _codChiamata;
    
    if (presente = 0) then
		signal sqlstate '45000'
        set message_text = 'A questa chiamata non corrisponde un\'effettiva corsa';
	end if;
    
    select C.accountFruitore, C.codSharing into nome_utente_fruitore, cod_sharing
    from chiamata C
    where C.codChiamata = _codChiamata;
    
    select R.codTragitto, R.utenteProponente into tragitto,  nome_utente_proponente
    from ride_sharing R
    where R.codSharing = cod_sharing;
    
    insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
	values (tragitto, nome_utente_proponente, 'proponente', nome_utente_fruitore, _valPersona, _valComportamento, _valSerieta, _recensione
	);
    
    select V.codValutazione into cod_valutazione
    from valutazione V
    order by V.codValutazione DESC
    limit 1;
    
    insert into valutazione_guida
    values (cod_valutazione, _valPiacereViaggio
    );
    
end $$





-- sesta operazione

drop procedure if exists ins_Prenotazione_di_pool_con_var;

delimiter $$

create procedure ins_Prenotazione_di_pool_con_var(
													in _codPool int,
													in _nomeUtente varchar(255),
													in _codVariazione int,
													in _stradaI int,
													in _kmI int,
													in _stradaF int,
													in _kmF int
													)
begin
	-- controlli
    declare cPool int default 0;
	declare cVariazione int default 0;
    
    select count(*)  into cPool
	from
		pool p
	where
		p.codPool = _codPool;
    
    
    if cPool = 0 then
		signal sqlstate '45000'
        set message_text = 'Errore in inserimento del codice del Pool';
	end if;
    
    
    
    
    select count(*)  into cVariazione
	from
		tragitto t
	where
		t.codice = _codVariazione ;
    
    
    if cVariazione = 0 then
		signal sqlstate '45000'
        set message_text = 'Errore in inserimento del codice della Variazione';
	end if;
    
    
    insert into prenotazione_di_pool (accountFruitore  ,codPool  ,codStradaInizio  ,kmInizio  ,codStradaFine  ,kmFine  ,codVariazione , accettataVariazione ,accettataPrenotazione)
    values ( _nomeUtente , _codPool ,  _stradaI , _kmI , _stradaF , _kmF , _codVariazione , null , null);
end$$
delimiter ;





-- settima operazione

drop procedure if exists lista_passeggeri;

delimiter $$

create procedure lista_passeggeri (
									in _codPool int
									)
begin
	select 
		u.nome,
        u.cognome,
        u.numeroTelefono,
        pp.codStradaInizio,
        pp.kmInizio,
        pp.codStradaFine,
        pp.kmFine,
        pp.codVariazione,
        t.daStradaInizio,
        t.daKmInizio,
        t.aStradaFine,
        t.aKmFine,
        (a.sommaValPersona / a.numeroValutazioni) as valMediaPersona,
        (a.sommaValComportamento / a.numeroValutazioni) as valMediaComportamento,
        (a.sommaValSerieta / a.numeroValutazioni) as valMediaSerieta
    from 
		prenotazione_di_pool pp
		inner join
        account a
        on
        pp.accountFruitore = a.nomeUtente
        inner join
        utente u
        on
        u.codFiscale = a.codFiscale
        inner join
        tragitto t
        on 
        t.codice = pp.codVariazione
	where
		pp.codPool = _codPool;
end$$
delimiter ;





-- ottava operazione

drop procedure if exists auto_disponibili_car_sharing;

delimiter $$

create procedure auto_disponibili_car_sharing (
												in _giorno date,
                                                in _oraInizio time,
                                                in _oraFine time
												)
begin
	
    declare giornoING varchar(255) default '';
    declare giornoIT varchar(255) default '';
    
    
    set giornoING = dayname(_giorno);
    case 
    when giornoING = 'Monday' then
		set giornoIT = 'lun';
	when giornoING = 'Tuesday' then
		set giornoIT = 'mar';
	when giornoING = 'Wednesday' then
		set giornoIT = 'mer';
	when giornoING = 'Thursday' then
		set giornoIT = 'gio';
	when giornoING = 'Friday' then
		set giornoIT = 'ven';
	when giornoING = 'Saturday' then
		set giornoIT = 'sab';
	when giornoING = 'Sunday' then
		set giornoIT = 'dom';
	end case;
    
    
    select
		go.targa,
        u.nome,
        u.cognome,
        u.numeroTelefono,
        i.via,
        i.comune,
        i.numeroCivico,
        i.provincia,
        i.regione,
        acs.numSharingPrecedenti,
        a.totKmPercorsi,
        a.totCarburante,
        m.nomeModello,
        m.casaProduttrice,
        m.cilindrata,
        m.numPosti,
        m.dimensioneBagaglio,
        ((m.consumoExtraurbano + m.consumoUrbano)/ 2) as consumoMisto,
        m.costoOperativo,
        m.tipoCarburante,
        (	select
				count(*)
			from
				possedere poss
			where
				poss.targa = go.targa
        ) as numeroOptional,
        (
			select
				count(sin.codSinistro)
			from
				sinistro sin
                inner join
                prenotazione_di_noleggio prenNol
                on
                prenNol.codice = sin.codNoleggio
			where
				prenNol.targa = go.targa
        ) as numSinistri
	from
        giorno_e_orario go
        inner join
        autovettura_car_sharing acs
        on
        go.targa = acs.targa
        inner join
        autovettura a
        on
        a.targa = go.targa
        inner join
        account acc
        on
        acc.nomeUtente = a.codAccountProprietario
        inner join
        utente u
        on
        u.codFiscale = acc.codFiscale
        inner join
        indirizzo i
        on
        i.codFiscale = u.codFiscale
        inner join 
        modello m
        on
		m.codModello = a.codModello
	where
		go.giorno = giornoIT
        and
        go.oraInizio <= _oraInizio
        and
        go.oraFine >= _oraFine
        and
        go.targa not in	(
						select
							pn.targa
						from
							prenotazione_di_noleggio pn
						where
							pn.dataInizio = _giorno
                            and
                            pn.dataFine = _giorno
                            and
                            pn.oraInizio <= _oraInizio
                            and
                            pn.oraFine >= _oraFine
                        )
		;
end$$
delimiter ;







-- AREA UTENTI

-- Dario Lampa

INSERT into utente
values ('LMPDRA78S01A657A', 'Dario', 'Lampa', '3538203002', 
'attivo');

insert into indirizzo 
values ('LMPDRA78S01A657A', 'Via del merlo', 4, 'Barga', 
	'Toscana', 55051, 'Lucca'
);
    
insert into iscrizione
values ('LMPDRA78S01A657A', current_date(), 'Carta di identità', 
	012345, '2020-05-20', 'Comune'
);

insert into account
values ('Lampadario', 'P@ssword', 
	'Qual è il mio numero di telefono?', '3538203002', 
	'LMPDRA78S01A657A', 0, 0, 0, 0
);

insert into Ruolo
values ('Lampadario', 'proponente'
);


-- Nicola Cappuccio

INSERT into utente
values ('CPPNCL78A07G702T', 'Nicola', 'Cappuccio', '3882594366', 
'attivo');

insert into indirizzo 
values ('CPPNCL78A07G702T', 'Via Damiano Chiesa', 10, 'Pisa', 
	'Toscana', 56121, 'Pisa'
);

insert into iscrizione
values ('CPPNCL78A07G702T', current_date(), 'Carta di identità', 
	000001, '2020-01-10', 'Comune'
);

insert into account
values ('NicolaCappuccio', 'ciaociao', 
	'Qual è il mio numero di telefono?', '3882594366', 
	'CPPNCL78A07G702T', 0, 0, 0, 0
);

insert into Ruolo
values ('NicolaCappuccio', 'proponente'
);

insert into Ruolo
values ('NicolaCappuccio', 'fruitore'
);


-- Perla Pace 
-- Non può essere creato l'account poichè ha uno stato inattivo

INSERT into utente
values ('PCAPRL92M45G702W', 'Perla', 'Pace', '3229475833', 
'inattivo');

insert into indirizzo 
values ('PCAPRL92M45G702W', 'Via S.Tommaso', 23, 'Pisa', 
	'Toscana', 56121, 'Pisa'
);

insert into iscrizione
values ('PCAPRL92M45G702W', current_date(), 'Carta di identità', 
	000002, '2022-01-27', 'Comune'
);


-- Santa Rita

INSERT into utente
values ('RTISNT71E49E715I', 'Santa', 'Rita', '3775241369', 
'attivo');

insert into indirizzo 
values ('RTISNT71E49E715I', 'Via Romana', 17, 'Lucca', 
	'Toscana', 55100, 'Lucca'
);

insert into iscrizione
values ('RTISNT71E49E715I', current_date(), 'Carta di identità', 
	000003, '2025-01-10', 'Comune'
);

insert into account
values ('SantaRita', 'laMiaPassword', 
	'Qual è il nome del mio cane?', 'Bonnie', 
	'RTISNT71E49E715I', 0, 0, 0, 0
);

insert into Ruolo
values ('SantaRita', 'fruitore'
);


-- Placido Rossi

INSERT into utente
values ('RSSPCD41B09G702Q', 'Placido', 'Rossi', '3778574999', 
'attivo');

insert into indirizzo 
values ('RSSPCD41B09G702Q', 'Via Carlo Piaggia', 11, 'Lucca', 
	'Toscana', 55100, 'Lucca'
);

insert into iscrizione
values ('RSSPCD41B09G702Q', current_date(), 'Carta di identità', 
	000004, '2019-07-10', 'Comune'
);

insert into account
values ('AlAn', 'Placido', 
	'Dove lavoro?', 'Esercito', 
	'RSSPCD41B09G702Q', 0, 0, 0, 0
);

insert into Ruolo
values ('AlAn', 'fruitore'
);

insert into Ruolo
values ('AlAn', 'proponente'
);


-- Luciana Carlotti

INSERT into utente
values ('CRLLCN84R49E715Q', 'Carlotti', 'Luciana', '3778877422', 
'attivo');

insert into indirizzo 
values ('CRLLCN84R49E715Q', 'Via S.Donato', 20, 'Lucca', 
	'Toscana', 55100, 'Lucca'
);

insert into iscrizione
values ('CRLLCN84R49E715Q', current_date(), 'Carta di identità', 
	000005, '2019-10-20', 'Comune'
);

insert into account
values ('LucianaCarlotti', 'sistemiTps', 
	'Posizione lavorativa?', 'Disoccupata', 
	'CRLLCN84R49E715Q', 0, 0, 0, 0
);

insert into Ruolo
values ('LucianaCarlotti', 'fruitore'
);

-- Ulisse Dini 

INSERT into utente
values ('DNILSS80A01E715F', 'Dini', 'Ulisse', '3409874123', 
'attivo');

insert into indirizzo 
values ('DNILSS80A01E715F', 'Viale Luporini', 26, 'Lucca', 
	'Toscana', 55100, 'Lucca'
);

insert into iscrizione
values ('DNILSS80A01E715F', current_date(), 'Carta di identità', 
	000006, '2026-11-25', 'Comune'
);

insert into account
values ('UlisseDini', 'psswrd', 
	'Numero di telefono?', '3409874123', 
	'DNILSS80A01E715F', 0, 0, 0, 0
);

insert into Ruolo
values ('UlisseDini', 'proponente'
);


-- Samuele Rugani 

INSERT into utente
values ('RGNSML80A01E715G', 'Rugani', 'Samuele', '3468736544', 
'attivo');

insert into indirizzo 
values ('RGNSML80A01E715G', 'Via Carlo Piagge', 30, 'Lucca', 
	'Toscana', 55100, 'Lucca'
);

insert into iscrizione
values ('RGNSML80A01E715G', current_date(), 'Carta di identità', 
	000007, '2020-02-25', 'Comune'
);

insert into account
values ('Rugans', 'centonovantadue', 
	'Sport preferito?', 'Football', 
	'RGNSML80A01E715G', 0, 0, 0, 0
);

insert into Ruolo
values ('Rugans', 'fruitore'
);




-- CARBURANTE

insert into carburante
values ('benzina', 1.664);

insert into carburante
values ('gasolio', 1.564);

insert into carburante
values ('metano', 0.993);

insert into carburante
values ('gpl', 0.699);





-- OPTIONAL

insert into optional
values (1, 'tetto in vetro');

insert into optional
values (2, 'luci led');

insert into optional
values (3, '4x4');

insert into optional
values (4, 'navigatore');

insert into optional
values (5, 'wi-fi');

insert into optional
values (6, 'clima automatico');

insert into optional
values (7, 'frenata di emergenza');

insert into optional
values (8, 'radio');

insert into optional
values (9, 'sedili riscaldabili');

insert into optional
values (10, 'air-bag');







-- MODELLO


insert into modello
values ( 1, 'fiat' , 'Panda' , 1200 , 5 , 200 , 1.5 , 'benzina' , 55 , 164 , 0.0564 , 0.0429 , 1.5 , 0.58 ,1.36 );

insert into modello
values ( 2, 'mercedes' , 'classe a' , 1461 , 5 , 341 , 1.18 , 'gasolio' , 60 , 192.1 , 0.0429 , 0.037 , 2.5 , 1.02 , 2.64 );

insert into modello
values ( 3, 'volkswagen' , 'Polo' , 1000 , 5 , 351 , 1.32 , 'gpl' , 50 , 170 , 0.0602 , 0.0436 , 1.7 , 0.65 , 1.25 );





-- AUTOVETTURA

-- 1 
insert into autovettura
values ( 'EB460KL' , 'Lampadario' , 2010 , 1 , 203659 , 15.6 , 3 );

insert into possedere
values ( 'EB460KL' , 8 );

insert into possedere
values ( 'EB460KL' , 10 );

insert into autovettura_car_sharing
values ( 'EB460KL' , 'disponibile' , 0 );




-- 2
insert into autovettura
values ( 'FA890TF' , 'AlAn' , 2017 , 2 , 30647 , 37.3 , 4 );

insert into possedere
values ( 'FA890TF' , 8 );

insert into possedere
values ( 'FA890TF' , 10 );

insert into possedere
values ( 'FA890TF' , 1 );

insert into possedere
values ( 'FA890TF' , 2 );

insert into possedere
values ( 'FA890TF' , 4 );

insert into possedere
values ( 'FA890TF' , 6 );

insert into autovettura_car_sharing
values ( 'FA890TF' , 'disponibile' , 0 );




-- 3
insert into autovettura
values ( 'BS543CR' , 'UlisseDini' , 2007 , 3 , 340647 , 27.3 , 2 );

insert into possedere
values ( 'BS543CR' , 8 );

insert into possedere
values ( 'BS543CR' , 10 );

insert into possedere
values ( 'BS543CR' , 4 );

insert into possedere
values ( 'BS543CR' , 6 );

insert into autovettura_car_sharing
values ( 'BS543CR' , 'disponibile' , 0 );





-- 4
insert into autovettura
values ( 'AL007AN' , 'AlAn' , 2017 , 1 , 164500 , 28.7 , 1 );

insert into possedere
values ( 'AL007AN' , 8 );

insert into possedere
values ( 'AL007AN' , 10 );

insert into possedere
values ( 'AL007AN' , 3 );

insert into possedere
values ( 'AL007AN' , 5 );

insert into possedere
values ( 'AL007AN' , 7 );

insert into possedere
values ( 'AL007AN' , 9 );





-- STRADE

-- autostrada A8/A26

insert into strada
values ( 1 , 'ss', 1 , null , null , '8', 20 , 2 , 2, 2, 'a');

insert into doppionome
values (26, 1);

insert into chilometro
values (1 , 1 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 2 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 3 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 4 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 5 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 6 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 7 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 8 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 9 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 10 , 43.89576 , 10.75944 , 31 , 110 );

insert into chilometro
values (1 , 11 , 43.89576 , 10.75944 , 31 , 110 );

insert into chilometro
values (1 , 12 , 43.89576 , 10.75944 , 31 , 110 );

insert into chilometro
values (1 , 13 , 43.89576 , 10.75944 , 31 , 110 );

insert into chilometro
values (1 , 14 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 15 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 16 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 17 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 18 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 19 , 43.89576 , 10.75944 , 27 , 130 );

insert into chilometro
values (1 , 20 , 43.89576 , 10.75944 , 27 , 130 );



-- RACCORDI

insert into strada
values ( 2 , 'sr', 1 , 'racc' , null , null , 2 , 1 , 1 , 1 , 'es');

insert into chilometro
values (2 , 1 , 43.89576 , 10.75944 , 56 , 40 );

insert into chilometro
values (2 , 2 , 43.89576 , 10.75944 , 56 , 40 );

insert into incrocio
values (1,2,19,1);





insert into strada
values ( 3 , 'sr', 2 , 'racc' , null , null , 2 , 1 , 1 , 1 , 'es');

insert into chilometro
values (3 , 1 , 43.89576 , 10.75944 , 56 , 40 );

insert into chilometro
values (3 , 2 , 43.89576 , 10.75944 , 56 , 40 );

insert into incrocio
values (1,3,19,1);





insert into strada
values ( 4 , 'sr', 3 , 'racc' , null , null , 2 , 1 , 1 , 1 , 'es');

insert into chilometro
values (4 , 1 , 43.89576 , 10.75944 , 56 , 40 );

insert into chilometro
values (4 , 2 , 43.89576 , 10.75944 , 56 , 40 );

insert into incrocio
values (1,4,2,1);





insert into strada
values ( 5 , 'sr', 4 , 'racc' , null , null , 2 , 1 , 1 , 1 , 'es');

insert into chilometro
values (5 , 1 , 43.89576 , 10.75944 , 56 , 40 );

insert into chilometro
values (5 , 2 , 43.89576 , 10.75944 , 56 , 40 );

insert into incrocio
values (1,5,2,1);

-- altre strade



insert into strada
values ( 6 , 'sp', 1 , 'var' , null , null , 2 , 1 , 2 , 1 , 'ep');

insert into chilometro
values (6 , 1 , 43.89576 , 10.75944 , 40 , 70 );

insert into chilometro
values (6 , 2 , 43.89576 , 10.75944 , 40 , 70 );

insert into incrocio
values (2,6,2,1);

insert into incrocio
values (3,6,2,2);




insert into strada
values ( 7 , 'ss', 2 , null , 'bis' , 'via damiano chiesa', 3 , 1 , 1 , 2 , 'u');

insert into chilometro
values (7 , 1 , 43.89576 , 10.75944 , 40 , 50 );

insert into chilometro
values (7 , 2 , 43.89576 , 10.75944 , 40 , 50 );

insert into chilometro
values (7 , 3 , 43.89576 , 10.75944 , 40 , 50 );

insert into incrocio
values (7,6,1,1);

insert into incrocio
values (7,6,3,2);






insert into strada
values ( 8 , 'sp', 2 , null , null , 'via san donato', 3 , 2 , 2 , 2 , 'u');

insert into chilometro
values (8 , 1 , 43.89576 , 10.75944 , 45 , 60 );

insert into chilometro
values (8 , 2 , 43.89576 , 10.75944 , 45 , 60 );

insert into chilometro
values (8 , 3 , 43.89576 , 10.75944 , 45 , 60 );

insert into incrocio
values (8,4,1,2);

insert into incrocio
values (8,5,2,2);





insert into strada
values ( 9 , 'sv', 1 , null , 'ter' , 'via romana', 2 , 2 , 1 , 2 , 'u');

insert into chilometro
values (9 , 1 , 43.89576 , 10.75944 , 70 , 30 );

insert into chilometro
values (9 , 2 , 43.89576 , 10.75944 , 70 , 30 );

insert into incrocio
values (9,8,1,3);






insert into strada
values ( 10 , 'sp', 3 , 'var' , null , null, 3 , 1 , 1 , 1 , 'es');

insert into chilometro
values (10 , 1 , 43.89576 , 10.75944 , 33 , 100 );

insert into chilometro
values (10 , 2 , 43.89576 , 10.75944 , 33 , 100 );

insert into chilometro
values (10 , 3 , 43.89576 , 10.75944 , 33 , 100 );

insert into incrocio
values (10,9,1,1);





insert into strada
values ( 11 , 'ss', 4 , 'dir' , null , null, 6 , 2 , 1 , 2 , 'ep');

insert into chilometro
values (11 , 1 , 43.89576 , 10.75944 , 35 , 90 );

insert into chilometro
values (11 , 2 , 43.89576 , 10.75944 , 35 , 90 );

insert into chilometro
values (11 , 3 , 43.89576 , 10.75944 , 35 , 90 );

insert into chilometro
values (11 , 4 , 43.89576 , 10.75944 , 35 , 90 );

insert into chilometro
values (11 , 5 , 43.89576 , 10.75944 , 35 , 90 );

insert into chilometro
values (11 , 6 , 43.89576 , 10.75944 , 35 , 90 );

insert into incrocio
values (11,10,1,3);






insert into strada
values ( 12 , 'sr', 6 , null , null , 'via del merlo', 3 , 1 , 1 , 2 , 'u');

insert into chilometro
values (12 , 1 , 43.89576 , 10.75944 , 70 , 30 );

insert into chilometro
values (12 , 2 , 43.89576 , 10.75944 , 70 , 30 );

insert into chilometro
values (12 , 3 , 43.89576 , 10.75944 , 70 , 30 );

insert into incrocio
values (12,11,1,6);





insert into strada
values ( 13 , 'sc', 1 , null , 'quater' , null , 2 , 1 , 2 , 2 , 'u');

insert into chilometro
values (13 , 1 , 43.89576 , 10.75944 , 50 , 50 );

insert into chilometro
values (13 , 2 , 43.89576 , 10.75944 , 50 , 50 );

insert into incrocio
values (13,11,1,1);





insert into strada
values ( 14 , 'sv', 2 , null , null , 'via carlo piaggia', 3 , 1 , 2 , 2 , 'u');

insert into chilometro
values (14 , 1 , 43.89576 , 10.75944 , 70 , 30 );

insert into chilometro
values (14 , 2 , 43.89576 , 10.75944 , 70 , 30 );

insert into chilometro
values (14 , 3 , 43.89576 , 10.75944 , 70 , 30 );

insert into incrocio
values (14,13,1,2);





insert into strada
values ( 15 , 'sp', 4 , 'radd' , null , null, 3 , 2 , 2 , 2 , 'u');

insert into chilometro
values (15 , 1 , 43.89576 , 10.75944 , 56 , 70 );

insert into chilometro
values (15 , 2 , 43.89576 , 10.75944 , 56 , 70 );

insert into chilometro
values (15 , 3 , 43.89576 , 10.75944 , 56 , 70 );

insert into incrocio
values (15,14,1,1);

insert into incrocio
values (15,4,3,2);




insert into strada
values ( 16 , 'sc', 2 , null , 'ter' , 'viale luporini' , 3 , 1 , 1 , 2 , 'u');

insert into chilometro
values (16 , 1 , 43.89576 , 10.75944 , 40 , 50 );

insert into chilometro
values (16 , 2 , 43.89576 , 10.75944 , 40 , 50 );

insert into chilometro
values (16 , 3 , 43.89576 , 10.75944 , 40 , 50 );

insert into incrocio
values (16,15,1,2);




-- PEDAGGIO


insert into pedaggio
values (1 , 1 , 0.2 );

insert into pedaggio
values (1 , 2 , 0.2 );

insert into pedaggio
values (1 , 3 , 0.2 );

insert into pedaggio
values (1 , 4 , 0.2 );

insert into pedaggio
values (1 , 5 , 0.2 );

insert into pedaggio
values (1 , 6 , 0.2 );

insert into pedaggio
values (1 , 7 , 0.2);

insert into pedaggio
values (1 , 8 , 0.2 );

insert into pedaggio
values (1 , 9 , 0.2);

insert into pedaggio
values (1 , 10 , 0.5 );

insert into pedaggio
values (1 , 11 , 0.5 );

insert into pedaggio
values (1 , 12 , 0.5 );

insert into pedaggio
values (1 , 13 , 0.5 );

insert into pedaggio
values (1 , 14 , 0.2 );

insert into pedaggio
values (1 , 15 , 0.2);

insert into pedaggio
values (1 , 16 , 0.2 );

insert into pedaggio
values (1 , 17 , 0.2);

insert into pedaggio
values (1 , 18 , 0.2 );

insert into pedaggio
values (1 , 19 , 0.2 );

insert into pedaggio
values (1 , 20 , 0.2 );





-- CAR SHARING

-- GIORNO E ORARIO

insert into giorno_e_orario
values ('EB460KL', 'lun', '09:00:00', '15:00:00'
);

insert into giorno_e_orario
values ('EB460KL', 'mer', '14:00:00', '20:00:00'
);

insert into giorno_e_orario
values ('EB460KL', 'ven', '10:00:00', '16:00:00'
);

insert into giorno_e_orario
values ('FA890TF', 'gio', '12:00:00', '19:00:00'
);

insert into giorno_e_orario
values ('FA890TF', 'sab', '18:00:00', '23:00:00'
);

insert into giorno_e_orario
values ('FA890TF', 'dom', '08:00:00', '21:00:00'
);

insert into giorno_e_orario
values ('BS543CR', 'lun', '09:00:00', '15:00:00'
);

insert into giorno_e_orario
values ('BS543CR', 'mer', '14:00:00', '20:00:00'
);

insert into giorno_e_orario
values ('BS543CR', 'ven', '10:00:00', '16:00:00'
);
insert into giorno_e_orario
values ('FA890TF', 'lun', '09:00:00', '15:00:00'
);

-- primo 
-- prende la macchina in viale luporini, da casa di Ulisse Dini
insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (16,2,16,2);
insert into composto(codStrada, numKm, codTragitto)
values (16,2,1
);
insert into composto(codStrada, numKm, codTragitto)
values (16,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (15,2,1
);
insert into composto(codStrada, numKm, codTragitto)
values (15,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (14,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (13,2,1
);
insert into composto(codStrada, numKm, codTragitto)
values (13,1,1
);
-- arrivato fino a quel punto e torna indietro
insert into composto(codStrada, numKm, codTragitto)
values (13,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (13,2,1
);
insert into composto(codStrada, numKm, codTragitto)
values (14,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (15,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (15,2,1
);
insert into composto(codStrada, numKm, codTragitto)
values (16,1,1
);
insert into composto(codStrada, numKm, codTragitto)
values (16,2,1
);

insert into prenotazione_di_noleggio(utenteFruitore, targa, dataInizio, dataFine, oraInizio, oraFine, 
			accettata, codTragitto)
values (
	'AlAn', 'BS543CR', '2018-10-12', '2018-10-12', '11:00:00', '13:00:00' , 'si', 1
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'AlAn', 'fruitore', 'UlisseDini', 5, 4, 5, 'Sono molto contento di come ha trattato la mia macchina'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'UlisseDini', 'proponente', 'AlAn', 4, 4, 5, 'Sono molto contento della macchina utilizzata'
);

-- tracking
insert into tracking
values ('BS543CR',16,2, '2018-10-12 11:30:27'
);
insert into tracking
values ('BS543CR',16,1,'2018-10-12 11:30:47'
);
insert into tracking
values ('BS543CR',15,2,'2018-10-12 11:31:07'
);
insert into tracking
values ('BS543CR',15,1,'2018-10-12 11:31:27'
);
insert into tracking
values ('BS543CR',14,1,'2018-10-12 11:31:47'
);
insert into tracking
values ('BS543CR',13,2, '2018-10-12 11:32:07'
);
insert into tracking
values ('BS543CR',13,1,'2018-10-12 11:32:27'
);
-- arrivato fino a quel punto e torna indietro
insert into tracking
values ('BS543CR',13,1,'2018-10-12 12:28:25'
);
insert into tracking
values ('BS543CR',13,2, '2018-10-12 12:28:45'
);
insert into tracking
values ('BS543CR',14,1,'2018-10-12 12:29:05'
);
insert into tracking
values ('BS543CR',15,1,'2018-10-12 12:29:25'
);
insert into tracking
values ('BS543CR',15,2,'2018-10-12 12:29:45'
);
insert into tracking
values ('BS543CR',16,1,'2018-10-12 12:30:05'
);
insert into tracking
values ('BS543CR',16,2, '2018-10-12 12:30:25'
);

-- update finale quando arriva alla torretta
update prenotazione_di_noleggio
set totCarburante = 24.57
where targa = 'BS543CR';


-- secondo
-- Rugans prende la macchina di Alan in via carlo piagga

insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (14,2,14,2);

insert into composto(codStrada, numKm, codTragitto)
values (14,2,2
);
insert into composto(codStrada, numKm, codTragitto)
values (14,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (13,2,2
);
insert into composto(codStrada, numKm, codTragitto)
values (13,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (10,3,2
);
insert into composto(codStrada, numKm, codTragitto)
values (10,2,2
);
insert into composto(codStrada, numKm, codTragitto)
values (10,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (8,3,2
);
insert into composto(codStrada, numKm, codTragitto)
values (8,2,2
);
insert into composto(codStrada, numKm, codTragitto)
values (8,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (15,3,2
);
insert into composto(codStrada, numKm, codTragitto)
values (15,2,2
);
insert into composto(codStrada, numKm, codTragitto)
values (15,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (14,1,2
);
insert into composto(codStrada, numKm, codTragitto)
values (14,2,2
);

insert into prenotazione_di_noleggio(utenteFruitore, targa, dataInizio, dataFine, oraInizio, oraFine, 
			accettata, codTragitto)
values (
	'Rugans', 'FA890TF', '2018-10-14', '2018-10-14', '09:00:00', '11:00:00' , 'si', 2
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'Rugans','fruitore','AlAn', 3, 2, 2, 'Ritengo che si sia comportato in modo scorretto'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'AlAn', 'proponente', 'Rugans', 4, 4, 5, 'Sono soddisfatto della macchina'
);


-- tracking
insert into tracking
values ('FA890TF',14,2,'2018-10-14 09:00:00'
);
insert into tracking
values ('FA890TF',14,1,'2018-10-14 09:00:20'
);
insert into tracking
values ('FA890TF',13,2,'2018-10-14 09:00:40'
);
insert into tracking
values ('FA890TF',13,1,'2018-10-14 09:01:00'
);
insert into tracking
values ('FA890TF',10,3,'2018-10-14 09:01:20'
);
insert into tracking
values ('FA890TF',10,2,'2018-10-14 09:01:40'
);
insert into tracking
values ('FA890TF',10,1,'2018-10-14 09:02:00'
);
insert into tracking
values ('FA890TF',8,3,'2018-10-14 09:02:20'
);
insert into tracking
values ('FA890TF',8,2,'2018-10-14 09:02:40'
);
insert into tracking
values ('FA890TF',8,1,'2018-10-14 10:58:20'
);
insert into tracking
values ('FA890TF',15,3,'2018-10-14 10:58:40'
);
insert into tracking
values ('FA890TF',15,2,'2018-10-14 10:59:00'
);
insert into tracking
values ('FA890TF',15,1,'2018-10-14 10:59:20'
);
insert into tracking
values ('FA890TF',14,1,'2018-10-14 10:59:40'
);
insert into tracking
values ('FA890TF',14,2,'2018-10-14 11:00:00'
);

-- update finale quando arriva alla torretta
update prenotazione_di_noleggio
set totCarburante = 35.4
where targa = 'FA890TF';

-- terza
-- SantaRita da casa di Ulisse Dini passando per l'autostrada

insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (16,2,16,2);

insert into composto(codStrada, numKm, codTragitto)
values (16,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (16,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (15,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (15,3,3
);
insert into composto(codStrada, numKm, codTragitto)
values (4,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (4,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,3,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,4,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,5,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,6,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,7,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,8,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,9,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,10,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,11,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,12,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,13,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,14,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,15,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,16,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,17,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,18,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,19,3
);
insert into composto(codStrada, numKm, codTragitto)
values (2,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (2,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (7,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (7,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (7,3,3
);
insert into composto(codStrada, numKm, codTragitto)
values (3,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (3,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,19,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,18,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,17,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,16,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,15,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,14,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,13,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,12,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,11,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,10,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,9,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,8,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,7,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,6,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,5,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,4,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,3,3
);
insert into composto(codStrada, numKm, codTragitto)
values (1,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (5,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (5,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (8,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (8,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (15,3,3
);
insert into composto(codStrada, numKm, codTragitto)
values (15,2,3
);
insert into composto(codStrada, numKm, codTragitto)
values (16,1,3
);
insert into composto(codStrada, numKm, codTragitto)
values (16,2,3
);

insert into prenotazione_di_noleggio(utenteFruitore, targa, dataInizio, dataFine, oraInizio, oraFine, 
			accettata, codTragitto)
values (
	'SantaRita', 'BS543CR', '2018-10-17', '2018-10-17', '15:00:00', '19:00:00' , 'si', 3
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'SantaRita','fruitore','UlisseDini', 4, 5, 4, 'Sono soddisfatto'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (1,'UlisseDini', 'proponente', 'SantaRita', 4, 4, 4, 'Sono soddisfatto del servizio'
);



-- tracking
insert into tracking
values ('BS543CR',16,2,'2018-10-17 15:00:40'
);
insert into tracking
values ('BS543CR',16,1,'2018-10-17 15:01:00'
);
insert into tracking
values ('BS543CR',15,2,'2018-10-17 15:01:20'
);
insert into tracking
values ('BS543CR',15,3,'2018-10-17 15:01:40'
);
insert into tracking
values ('BS543CR',4,2,'2018-10-17 15:02:00'
);
insert into tracking
values ('BS543CR',4,1,'2018-10-17 15:02:20'
);
insert into tracking
values ('BS543CR',1,2,'2018-10-17 15:02:40'
);
insert into tracking
values ('BS543CR',1,3,'2018-10-17 15:03:00'
);
insert into tracking
values ('BS543CR',1,4,'2018-10-17 15:03:20'
);
insert into tracking
values ('BS543CR',1,5,'2018-10-17 15:03:40'
);
insert into tracking
values ('BS543CR',1,6,'2018-10-17 15:04:00'
);
insert into tracking
values ('BS543CR',1,7,'2018-10-17 15:04:20'
);
insert into tracking
values ('BS543CR',1,8,'2018-10-17 15:04:40'
);
insert into tracking
values ('BS543CR',1,9,'2018-10-17 15:05:00'
);
insert into tracking
values ('BS543CR',1,10,'2018-10-17 15:05:20'
);
insert into tracking
values ('BS543CR',1,11,'2018-10-17 15:05:40'
);
insert into tracking
values ('BS543CR',1,12,'2018-10-17 15:06:00'
);
insert into tracking
values ('BS543CR',1,13,'2018-10-17 15:06:20'
);
insert into tracking
values ('BS543CR',1,14,'2018-10-17 15:06:40'
);
insert into tracking
values ('BS543CR',1,15,'2018-10-17 15:07:00'
);
insert into tracking
values ('BS543CR',1,16,'2018-10-17 15:07:20'
);
insert into tracking
values ('BS543CR',1,17,'2018-10-17 15:07:40'
);
insert into tracking
values ('BS543CR',1,18,'2018-10-17 15:08:00'
);
insert into tracking
values ('BS543CR',1,19,'2018-10-17 15:08:20'
);
insert into tracking
values ('BS543CR',2,1,'2018-10-17 15:08:40'
);
insert into tracking
values ('BS543CR',2,2,'2018-10-17 15:09:00'
);
insert into tracking
values ('BS543CR',7,1,'2018-10-17 15:09:20'
);
insert into tracking
values ('BS543CR',7,2,'2018-10-17 15:09:40'
);
-- pausa - si ferma un po'
insert into tracking
values ('BS543CR',7,3,'2018-10-17 18:50:40'
);
insert into tracking
values ('BS543CR',3,2,'2018-10-17 18:51:00'
);
insert into tracking
values ('BS543CR',3,1,'2018-10-17 18:51:20'
);
insert into tracking
values ('BS543CR',1,19,'2018-10-17 18:51:40'
);
insert into tracking
values ('BS543CR',1,18,'2018-10-17 18:52:00'
);
insert into tracking
values ('BS543CR',1,17,'2018-10-17 18:52:20'
);
insert into tracking
values ('BS543CR',1,16,'2018-10-17 18:52:40'
);
insert into tracking
values ('BS543CR',1,15,'2018-10-17 18:53:00'
);
insert into tracking
values ('BS543CR',1,14,'2018-10-17 18:53:20'
);
insert into tracking
values ('BS543CR',1,13,'2018-10-17 18:53:40'
);
insert into tracking
values ('BS543CR',1,12,'2018-10-17 18:54:00'
);
insert into tracking
values ('BS543CR',1,11,'2018-10-17 18:54:20'
);
insert into tracking
values ('BS543CR',1,10,'2018-10-17 18:54:40'
);
insert into tracking
values ('BS543CR',1,9,'2018-10-17 18:55:00'
);
insert into tracking
values ('BS543CR',1,8,'2018-10-17 18:55:20'
);
insert into tracking
values ('BS543CR',1,7,'2018-10-17 18:55:40'
);
insert into tracking
values ('BS543CR',1,6,'2018-10-17 18:56:00'
);
insert into tracking
values ('BS543CR',1,5,'2018-10-17 18:56:20'
);
insert into tracking
values ('BS543CR',1,4,'2018-10-17 18:56:40'
);
insert into tracking
values ('BS543CR',1,3,'2018-10-17 18:57:00'
);
insert into tracking
values ('BS543CR',1,2,'2018-10-17 18:57:20'
);
insert into tracking
values ('BS543CR',5,1,'2018-10-17 18:57:40'
);
insert into tracking
values ('BS543CR',5,2,'2018-10-17 18:58:00'
);
insert into tracking
values ('BS543CR',8,2,'2018-10-17 18:58:20'
);
insert into tracking
values ('BS543CR',8,1,'2018-10-17 18:58:40'
);
insert into tracking
values ('BS543CR',15,3,'2018-10-17 18:59:00'
);
insert into tracking
values ('BS543CR',15,2,'2018-10-17 18:59:20'
);
insert into tracking
values ('BS543CR',16,1,'2018-10-17 18:59:40'
);
insert into tracking
values ('BS543CR',16,2,'2018-10-17 19:00:00'
);

-- update finale quando arriva alla torretta
update prenotazione_di_noleggio
set totCarburante = 24.57
where targa = 'BS543CR';

-- quarto - con sinistro
-- LucianaCarlotti con la macchina di Alan
insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (14,2,14,2);

insert into composto(codStrada, numKm, codTragitto)
values (14,2,4
);
insert into composto(codStrada, numKm, codTragitto)
values (14,1,4
);
insert into composto(codStrada, numKm, codTragitto)
values (13,2,4
);
insert into composto(codStrada, numKm, codTragitto)
values (13,1,4
);
insert into composto(codStrada, numKm, codTragitto)
values (11,1,4
);
insert into composto(codStrada, numKm, codTragitto)
values (11,2,4
);
insert into composto(codStrada, numKm, codTragitto)
values (11,3,4
);

insert into prenotazione_di_noleggio(utenteFruitore, targa, dataInizio, dataFine, oraInizio, oraFine, 
			accettata, codTragitto)
values (
	'LucianaCarlotti', 'FA890TF', '2018-10-11', '2018-10-11', '13:00:30', null , 'si', 4
);

-- tracking
insert into tracking
values ('FA890TF',14,2,'2018-10-11 13:00:30'
);
insert into tracking
values ('FA890TF',14,1,'2018-10-11 13:00:50'
);
insert into tracking
values ('FA890TF',13,2,'2018-10-11 13:01:10'
);
insert into tracking
values ('FA890TF',13,1,'2018-10-11 13:01:30'
);
insert into tracking
values ('FA890TF',11,1,'2018-10-11 13:01:50'
);
insert into tracking
values ('FA890TF',11,2,'2018-10-11 13:02:10'
);
insert into tracking
values ('FA890TF',11,3,'2018-10-11 13:02:30'
);

insert into sinistro(orario, codStrada, numKm, codNoleggio, dinamica)
values ('13:02:30', 11,3, 4, 'La macchina AB800BA non ha rispettato lo stop, incidentando la macchina sul lato destro'
);

insert into auto_coinvolte
values (1,'ABARTH 695', 'AB800BA', 'ABARTH'
);





-- CAR POOLING

-- primo: Ulisse Dini  

insert into Pool  (targa  ,dataPartenza  ,dataArrivo ,oraPartenza  ,oraArrivo ,flessibilita ,periodoValidita ,costoPercVar ,codTragitto )
values ('BS543CR', '2018-11-08', '2018-11-08', '15:00:00', '19:30:00', 'medio',  96 , 15 , 3 );

-- Prenota Nicola Cappuccio con variazione

-- inserisco la variazione
insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (8,2,8,2);

insert into composto(codStrada, numKm, codTragitto)
values (8,2,5);
insert into composto(codStrada, numKm, codTragitto)
values (8,3,5);
insert into composto(codStrada, numKm, codTragitto)
values (8,2,5);

insert into Prenotazione_Di_Pool (accountFruitore  ,codPool  ,codStradaInizio  ,kmInizio  ,codStradaFine  ,kmFine  ,codVariazione , accettataVariazione ,accettataPrenotazione)
values ('NicolaCappuccio' , 1 , 7 , 1, 8 ,2 , 5, 1, 1);

-- Tramite sesta operazione:
/*
call ins_Prenotazione_di_pool_con_var(
	1,'NicolaCappuccio',5,7,1,8,2
);
*/

-- tracking
insert into tracking
values ('BS543CR',16,2,'2018-11-08 15:00:40'
);
insert into tracking
values ('BS543CR',16,1,'2018-11-08 15:01:00'
);
insert into tracking
values ('BS543CR',15,2,'2018-11-08 15:01:20'
);
insert into tracking
values ('BS543CR',15,3,'2018-11-08 15:01:40'
);
insert into tracking
values ('BS543CR',4,2,'2018-11-08 15:02:00'
);
insert into tracking
values ('BS543CR',4,1,'2018-11-08 15:02:20'
);
insert into tracking
values ('BS543CR',1,2,'2018-11-08 15:02:40'
);
insert into tracking
values ('BS543CR',1,3,'2018-11-08 15:03:00'
);
insert into tracking
values ('BS543CR',1,4,'2018-11-08 15:03:20'
);
insert into tracking
values ('BS543CR',1,5,'2018-11-08 15:03:40'
);
insert into tracking
values ('BS543CR',1,6,'2018-11-08 15:04:00'
);
insert into tracking
values ('BS543CR',1,7,'2018-11-08 15:04:20'
);
insert into tracking
values ('BS543CR',1,8,'2018-11-08 15:04:40'
);
insert into tracking
values ('BS543CR',1,9,'2018-11-08 15:05:00'
);
insert into tracking
values ('BS543CR',1,10,'2018-11-08 15:05:20'
);
insert into tracking
values ('BS543CR',1,11,'2018-11-08 15:05:40'
);
insert into tracking
values ('BS543CR',1,12,'2018-11-08 15:06:00'
);
insert into tracking
values ('BS543CR',1,13,'2018-11-08 15:06:20'
);
insert into tracking
values ('BS543CR',1,14,'2018-11-08 15:06:40'
);
insert into tracking
values ('BS543CR',1,15,'2018-11-08 15:07:00'
);
insert into tracking
values ('BS543CR',1,16,'2018-11-08 15:07:20'
);
insert into tracking
values ('BS543CR',1,17,'2018-11-08 15:07:40'
);
insert into tracking
values ('BS543CR',1,18,'2018-11-08 15:08:00'
);
insert into tracking
values ('BS543CR',1,19,'2018-11-08 15:08:20'
);
insert into tracking
values ('BS543CR',2,1,'2018-11-08 15:08:40'
);
insert into tracking
values ('BS543CR',2,2,'2018-11-08 15:09:00'
);
insert into tracking
values ('BS543CR',7,1,'2018-11-08 15:09:20'
);
insert into tracking
values ('BS543CR',7,2,'2018-11-08 15:09:40'
);
-- pausa - si ferma un po'
insert into tracking
values ('BS543CR',7,3,'2018-11-08 18:50:40'
);
insert into tracking
values ('BS543CR',3,2,'2018-11-08 18:51:00'
);
insert into tracking
values ('BS543CR',3,1,'2018-11-08 18:51:20'
);
insert into tracking
values ('BS543CR',1,19,'2018-11-08 18:51:40'
);
insert into tracking
values ('BS543CR',1,18,'2018-11-08 18:52:00'
);
insert into tracking
values ('BS543CR',1,17,'2018-11-08 18:52:20'
);
insert into tracking
values ('BS543CR',1,16,'2018-11-08 18:52:40'
);
insert into tracking
values ('BS543CR',1,15,'2018-11-08 18:53:00'
);
insert into tracking
values ('BS543CR',1,14,'2018-11-08 18:53:20'
);
insert into tracking
values ('BS543CR',1,13,'2018-11-08 18:53:40'
);
insert into tracking
values ('BS543CR',1,12,'2018-11-08 18:54:00'
);
insert into tracking
values ('BS543CR',1,11,'2018-11-08 18:54:20'
);
insert into tracking
values ('BS543CR',1,10,'2018-11-08 18:54:40'
);
insert into tracking
values ('BS543CR',1,9,'2018-11-08 18:55:00'
);
insert into tracking
values ('BS543CR',1,8,'2018-11-08 18:55:20'
);
insert into tracking
values ('BS543CR',1,7,'2018-11-08 18:55:40'
);
insert into tracking
values ('BS543CR',1,6,'2018-11-08 18:56:00'
);
insert into tracking
values ('BS543CR',1,5,'2018-11-08 18:56:20'
);
insert into tracking
values ('BS543CR',1,4,'2018-11-08 18:56:40'
);
insert into tracking
values ('BS543CR',1,3,'2018-11-08 18:57:00'
);
insert into tracking
values ('BS543CR',1,2,'2018-11-08 18:57:20'
);
insert into tracking
values ('BS543CR',5,1,'2018-11-08 18:57:40'
);
insert into tracking
values ('BS543CR',5,2,'2018-11-08 18:58:00'
);
insert into tracking
values ('BS543CR',8,2,'2018-11-08 18:58:20'
);
insert into tracking
values ('BS543CR',8,3,'2018-11-08 18:58:40'
);
insert into tracking
values ('BS543CR',8,2,'2018-11-08 18:59:00'
);
insert into tracking
values ('BS543CR',8,1,'2018-11-08 18:59:20'
);
insert into tracking
values ('BS543CR',15,3,'2018-11-08 18:59:40'
);
insert into tracking
values ('BS543CR',15,2,'2018-11-08 19:00:00'
);
insert into tracking
values ('BS543CR',16,1,'2018-11-08 19:00:20'
);
insert into tracking
values ('BS543CR',16,2,'2018-11-08 19:00:40'
);

-- valutazione
insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (3,'NicolaCappuccio','fruitore','UlisseDini', 4, 5, 4, 'Sono soddisfatto'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (3,'UlisseDini','proponente', 'NicolaCappuccio', 4, 4, 4, 'Sono soddisfatto del servizio'
);

insert into  Valutazione_Guida (codValutazione ,valPiacereViaggio)
values (8, 3);

-- Tramite quarta operazione:
-- call valutazione_al_proponente_pool(1,4,4,4,'Sono soddisfatto del servizio', 3);


-- secondo: Alan

insert into Pool  (targa  ,dataPartenza  ,dataArrivo ,oraPartenza  ,oraArrivo ,flessibilita ,periodoValidita ,costoPercVar ,codTragitto )
values ('FA890TF', '2018-11-07', '2018-11-07', '09:00:00', '11:00:00', 'basso',  72 , 11 , 2 );

-- inserisco la variazione
insert into tragitto (daStradaInizio, daKmInizio, aStradaFine, aKmFine)
values (9,1,9,1);

insert into composto(codStrada, numKm, codTragitto)
values (9,1,6);
insert into composto(codStrada, numKm, codTragitto)
values (9,2,6);
insert into composto(codStrada, numKm, codTragitto)
values (9,1,6);


insert into Prenotazione_Di_Pool (accountFruitore  ,codPool  ,codStradaInizio  ,kmInizio  ,codStradaFine  ,kmFine  ,codVariazione , accettataVariazione ,accettataPrenotazione)
values ('SantaRita' , 2 , 10 , 1, 15 , 2, 6, null, 0);


-- tracking
insert into tracking
values ('FA890TF',14,2,'2018-11-07 09:00:00'
);
insert into tracking
values ('FA890TF',14,1,'2018-11-07 09:00:20'
);
insert into tracking
values ('FA890TF',13,2,'2018-11-07 09:00:40'
);
insert into tracking
values ('FA890TF',13,1,'2018-11-07 09:01:00'
);
insert into tracking
values ('FA890TF',10,3,'2018-11-07 09:01:20'
);
insert into tracking
values ('FA890TF',10,2,'2018-11-07 09:01:40'
);
insert into tracking
values ('FA890TF',10,1,'2018-11-07 09:02:00'
);
insert into tracking
values ('FA890TF',8,3,'2018-11-07 09:02:20'
);
insert into tracking
values ('FA890TF',8,2,'2018-11-07 09:02:40'
);
insert into tracking
values ('FA890TF',8,1,'2018-11-07 10:58:20'
);
insert into tracking
values ('FA890TF',15,3,'2018-11-07 10:58:40'
);
insert into tracking
values ('FA890TF',15,2,'2018-11-07 10:59:00'
);
insert into tracking
values ('FA890TF',15,1,'2018-11-07 10:59:20'
);
insert into tracking
values ('FA890TF',14,1,'2018-11-07 10:59:40'
);
insert into tracking
values ('FA890TF',14,2,'2018-11-07 11:00:00'
);

-- valutazione
insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (2,'SantaRita','fruitore','AlAn', 4, 5, 4, 'Poco male'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (2,'AlAn', 'proponente', 'SantaRita', 4, 4, 4, 'Risulta un tipo balordo'
);

insert into  Valutazione_Guida (codValutazione ,valPiacereViaggio)
values (10, 3);






-- RIDE SHARING


-- primo

insert into Ride_Sharing (targa  ,codTragitto ,oraPartenza  ,giornoPartenza  ,costoAlChilometro ,utenteProponente)
values ('BS543CR' , 3 , '15:00:00' , '2018-11-11' , 1 ,  'UlisseDini');

insert into Chiamata (accountFruitore  ,codSharing ,kmInizio ,codStradaInizio ,kmFine ,codStradaFine ,timeStamp ,stato , timeStampRisposta) 
values ('NicolaCappuccio' , 1 , 1 , 7, 2, 8, '2018-11-11 15:30:38', 'Accepted', '2018-11-11 15:32:13' );


insert into Corsa (codChiamata ,timeStampInizio ,timeStampFine )
values ( 1 , '2018-11-11 15:44:20', '2018-11-11 15:52:40');

-- tracking
insert into tracking
values ('BS543CR',16,2,'2018-11-11 15:35:40'
);
insert into tracking
values ('BS543CR',16,1,'2018-11-11 15:36:00'
);
insert into tracking
values ('BS543CR',15,2,'2018-11-11 15:36:20'
);
insert into tracking
values ('BS543CR',15,3,'2018-11-11 15:36:40'
);
insert into tracking
values ('BS543CR',4,2,'2018-11-11 15:37:00'
);
insert into tracking
values ('BS543CR',4,1,'2018-11-11 15:37:20'
);
insert into tracking
values ('BS543CR',1,2,'2018-11-11 15:37:40'
);
insert into tracking
values ('BS543CR',1,3,'2018-11-11 15:38:00'
);
insert into tracking
values ('BS543CR',1,4,'2018-11-11 15:38:20'
);
insert into tracking
values ('BS543CR',1,5,'2018-11-11 15:38:40'
);
insert into tracking
values ('BS543CR',1,6,'2018-11-11 15:39:00'
);
insert into tracking
values ('BS543CR',1,7,'2018-11-11 15:39:20'
);
insert into tracking
values ('BS543CR',1,8,'2018-11-11 15:39:40'
);
insert into tracking
values ('BS543CR',1,9,'2018-11-11 15:40:00'
);
insert into tracking
values ('BS543CR',1,10,'2018-11-11 15:40:20'
);
insert into tracking
values ('BS543CR',1,11,'2018-11-11 15:40:40'
);
insert into tracking
values ('BS543CR',1,12,'2018-11-11 15:41:00'
);
insert into tracking
values ('BS543CR',1,13,'2018-11-11 15:41:20'
);
insert into tracking
values ('BS543CR',1,14,'2018-11-11 15:41:40'
);
insert into tracking
values ('BS543CR',1,15,'2018-11-11 15:42:00'
);
insert into tracking
values ('BS543CR',1,16,'2018-11-11 15:42:20'
);
insert into tracking
values ('BS543CR',1,17,'2018-11-11 15:42:40'
);
insert into tracking
values ('BS543CR',1,18,'2018-11-11 15:43:00'
);
insert into tracking
values ('BS543CR',1,19,'2018-11-11 15:43:20'
);
insert into tracking
values ('BS543CR',2,1,'2018-11-11 15:43:40'
);
insert into tracking
values ('BS543CR',2,2,'2018-11-11 15:44:00'
);
insert into tracking
values ('BS543CR',7,1,'2018-11-11 15:44:20'
);
insert into tracking
values ('BS543CR',7,2,'2018-11-11 15:44:40'
);
insert into tracking
values ('BS543CR',7,3,'2018-11-11 15:45:00'
);
insert into tracking
values ('BS543CR',3,2,'2018-11-11 15:45:20'
);
insert into tracking
values ('BS543CR',3,1,'2018-11-11 15:45:40'
);
insert into tracking
values ('BS543CR',1,19,'2018-11-11 15:46:00'
);
insert into tracking
values ('BS543CR',1,18,'2018-11-11 15:46:20'
);
insert into tracking
values ('BS543CR',1,17,'2018-11-11 15:46:40'
);
insert into tracking
values ('BS543CR',1,16,'2018-11-11 15:47:00'
);
insert into tracking
values ('BS543CR',1,15,'2018-11-11 15:47:20'
);
insert into tracking
values ('BS543CR',1,14,'2018-11-11 15:47:40'
);
insert into tracking
values ('BS543CR',1,13,'2018-11-11 15:48:00'
);
insert into tracking
values ('BS543CR',1,12,'2018-11-11 15:48:20'
);
insert into tracking
values ('BS543CR',1,11,'2018-11-11 15:48:40'
);
insert into tracking
values ('BS543CR',1,10,'2018-11-11 15:49:00'
);
insert into tracking
values ('BS543CR',1,9,'2018-11-11 15:49:20'
);
insert into tracking
values ('BS543CR',1,8,'2018-11-11 15:49:40'
);
insert into tracking
values ('BS543CR',1,7,'2018-11-11 15:50:00'
);
insert into tracking
values ('BS543CR',1,6,'2018-11-11 15:50:20'
);
insert into tracking
values ('BS543CR',1,5,'2018-11-11 15:50:40'
);
insert into tracking
values ('BS543CR',1,4,'2018-11-11 15:51:00'
);
insert into tracking
values ('BS543CR',1,3,'2018-11-11 15:51:20'
);
insert into tracking
values ('BS543CR',1,2,'2018-11-11 15:51:40'
);
insert into tracking
values ('BS543CR',5,1,'2018-11-11 15:52:00'
);
insert into tracking
values ('BS543CR',5,2,'2018-11-11 15:52:20'
);
insert into tracking
values ('BS543CR',8,2,'2018-11-11 15:52:40'
);
insert into tracking
values ('BS543CR',8,3,'2018-11-11 15:53:00'
);
insert into tracking
values ('BS543CR',8,2,'2018-11-11 15:53:20'
);
insert into tracking
values ('BS543CR',8,1,'2018-11-11 15:53:40'
);
insert into tracking
values ('BS543CR',15,3,'2018-11-11 15:54:00'
);
insert into tracking
values ('BS543CR',15,2,'2018-11-11 15:54:20'
);
insert into tracking
values ('BS543CR',16,1,'2018-11-11 15:54:40'
);
insert into tracking
values ('BS543CR',16,2,'2018-11-11 15:55:00'
);


-- valutazione
insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (3,'NicolaCappuccio','fruitore','UlisseDini', 2, 5, 4, 'molto bravo'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (3,'UlisseDini', 'proponente', 'NicolaCappuccio', 3, 3, 3, 'non male'
);

insert into  Valutazione_Guida (codValutazione ,valPiacereViaggio)
values (12, 3);

-- Tramite quinta operazione 
-- call valutazione_al_proponente_ride_sharing(1,3,3,3,3,'non male');



-- secondo

insert into Ride_Sharing (targa  ,codTragitto ,oraPartenza  ,giornoPartenza  ,costoAlChilometro ,utenteProponente)
values ('FA890TF' , 2 , '17:00:00' , '2018-11-11' , 2 ,  'AlAn');

insert into Chiamata (accountFruitore  ,codSharing ,kmInizio ,codStradaInizio ,kmFine ,codStradaFine ,timeStamp ,stato , timeStampRisposta) 
values ('SantaRita' , 2 , 3 , 10, 3, 15, '2018-11-11 17:15:28', 'Accepted', '2018-11-11 17:18:22' );


insert into Corsa (codChiamata ,timeStampInizio ,timeStampFine )
values ( 2 , '2018-11-11 17:21:40', '2018-11-11 17:35:40');


-- tracking
insert into tracking
values ('FA890TF',14,2,'2018-11-11 17:20:20'
);
insert into tracking
values ('FA890TF',14,1,'2018-11-11 17:20:40'
);
insert into tracking
values ('FA890TF',13,2,'2018-11-11 17:21:00'
);
insert into tracking
values ('FA890TF',13,1,'2018-11-11 17:21:20'
);
insert into tracking
values ('FA890TF',10,3,'2018-11-11 17:21:40'
);
insert into tracking
values ('FA890TF',10,2,'2018-11-11 17:22:00'
);
insert into tracking
values ('FA890TF',10,1,'2018-11-11 17:22:20'
);
insert into tracking
values ('FA890TF',8,3,'2018-11-11 17:25:40'
);
insert into tracking
values ('FA890TF',8,2,'2018-11-11 17:26:00'
);
insert into tracking
values ('FA890TF',8,1,'2018-11-11 17:28:20'
);
insert into tracking
values ('FA890TF',15,3,'2018-11-11 17:35:40'
);
insert into tracking
values ('FA890TF',15,2,'2018-11-11 17:36:00'
);
insert into tracking
values ('FA890TF',15,1,'2018-11-11 17:38:20'
);
insert into tracking
values ('FA890TF',14,1,'2018-11-11 17:40:40'
);
insert into tracking
values ('FA890TF',14,2,'2018-11-11 17:42:00'
);


-- valutazione
insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (2,'SantaRita', 'fruitore', 'AlAn', 4, 5, 4, 'Poco male'
);

insert into valutazione(codTragitto, accountRiceve, ruoloRiceve, accountScrive, valPersona, 
						valComportamento, valSerieta, recensione)
values (2,'AlAn', 'proponente', 'SantaRita', 4, 4, 4, 'Bene dai pensavo peggio'
);

insert into  Valutazione_Guida (codValutazione ,valPiacereViaggio)
values (14, 3);







-- Event per MV_affidabilita_utenti

drop event if exists refresh_MV_affidabilita_utenti;

delimiter $$

create event refresh_MV_affidabilita_utenti
on schedule every 5 day
-- starts '2018-12-06 23:59:59'
do
begin
	declare finito int default 0;
    
    declare _account varchar(255) default '';
    declare _ruolo varchar(255) default '';
    declare _valPersona int default 0;
    declare _valComportamento int default 0;
    declare _valSerieta int default 0;
	declare _valPiacereViaggio int default 0;
    
    declare media double default 0;
    declare esiste int default 0;
    
    declare cursore cursor for
		select V.account, V.ruolo, V.valPersona, V.valComportamento, V.valSerieta, VG.valPiacereViaggio
		from valutazioni_log V left outer join valutazioni_guida_log VG on V.codValutazione = VG.codValutazione;
    
    declare continue handler for
    not found set finito = 1;
    
    open cursore;
    
    scan: loop
    
		fetch cursore into _account, _ruolo, _valPersona, _valComportamento, _valSerieta, _valPiacereViaggio;
        
        if finito = 1 then
			leave scan;
		end if;
        
        -- calcolo della media
        if (_valPiacereViaggio is not null) then
			set media = round((_valPersona + _valComportamento + _valSerieta + _valPiacereViaggio)/4, 2);
		else
			set media = round((_valPersona + _valComportamento + _valSerieta)/3, 2);
        end if;
        
        -- vado a vedere se la coppia account,ruolo esiste già nella MV, altrimenti la devo inserire
        -- se esiste incremento anche il numero di valutazioni, altrimenti lo setto a 1
        
        set esiste = 0;
        
        select count(*) into esiste
        from mv_affidabilita_utenti MAU
        where MAU.account = _account
        and MAU.ruolo = _ruolo;
        
        if (esiste > 0) then
			update mv_affidabilita_utenti MV
            set MV.sommaMedie = MV.sommaMedie + media, MV.numeroValutazioni = MV.numeroValutazioni + 1
			where MV.account = _account
            and MV.ruolo = _ruolo;
		else
			insert into mv_affidabilita_utenti
            values (_account, _ruolo, 1, media);
        end if;
        
	end loop scan;
    
    close cursore;
    
    truncate valutazioni_log;
    truncate valutazioni_guida_log;
end$$

delimiter ;

-- Event per MV_criticità_strade

drop event if exists refresh_MV_criticità_strade;

delimiter $$

create event refresh_MV_criticità_strade
on schedule every 5 minute
do
begin
	
    declare finito int default 0;
    declare codStrada int default 0;
    declare numKm int default 0;
    declare targa varchar(255) default'';
    
    
    declare tempoPercorrenza int default 0;
    declare primoRilevamento timestamp;
    declare ultimoRilevamento timestamp;
    
    
    declare tempoEffettivo int default 0;
    
    
    
    
    declare cursore cursor for
    select
		t.codStrada,
		t.numKm,
		t.targa
	from
		tracking t
	group by
		t.codStrada,
		t.numKm,
		t.targa
	having count(*) > 1;
    
    declare continue handler for
    not found set finito = 1;
    
    
    open cursore;
    
    scan: loop
    
		fetch cursore into codStrada,numKm,targa;
        
        if finito = 1 then
			leave scan;
		end if;
        
        
        select c.tempoPercorrenza into tempoPercorrenza
		from
			chilometro c
		where
			c.codStrada = codStrada
            and
            c.numKm = numKm;
        
        select min(tl.timeStamp) into primoRilevamento
		from
			tracking_log tl
		where
			tl.codStrada = codStrada
            and
            tl.numKm = numKm
            and
            tl.targa = targa;
        
        
        
        select max(tl.timeStamp) into ultimoRilevamento
		from
			tracking_log tl
		where
			tl.codStrada = codStrada
            and
            tl.numKm = numKm
            and
            tl.targa = targa;
        
        
        set tempoEffettivo =  time_to_sec(timediff(ultimoRilevamento,primoRilevamento));
        
        if tempoEffettivo > tempoPercorrenza then
			insert into MV_criticità_strade
            values (codStrada , numKm , ultimoRilevamento);
		end if;
        
        
	end loop scan;
    
    close cursore;
    
    truncate tracking_log;
end$$

delimiter ;


-- Prova delle operazioni

-- Prima operazione - Nuovo utente
/*
call nuovo_utente(
	'FRTFNC73R05G702K', 'Franco', 'Forte', '3347841900', 
    'Via Damiano Chiesa', 5, 'Pisa', 'Toscana', 56121, 'Pisa',
    'Carta di identità', '2026-10-01', 'Comune', 45, 
    'Francoforte', 'Elisabetta85', 'Il mio lavoro?', 'Carpentiere',
    2
);
*/
-- Seconda operazione - Calcolo della spesa dopo un servizio di car pooling
/*
call calcolo_spesa_car_pooling (2, @spesa);
select @spesa;
*/

-- Terza operazione - Calcolo della spesa dopo un servizio di ride sharing
/*
call spesa_ride_sharing(1,@spesa);
select @spesa;
*/

-- Quarta operazione - Valutazione al proponente dopo un servizio di car pooling
-- vedi riga 3430

-- Quinta operazione - Valutazione al proponente dopo un servizio di ride sharing
-- vedi riga 3730

-- Sesta operazione - Inserimento di una prenotazione di pool
-- vedi riga 3229

-- Settima operazione - Lista passeggeri del car pooling 
/*
call lista_passeggeri(1);
*/

-- Ottava operazione - Auto disponibili nel car sharing
/*
call auto_disponibili_car_sharing('2018-11-12', '09:01:00' , '14:59:00');
*/