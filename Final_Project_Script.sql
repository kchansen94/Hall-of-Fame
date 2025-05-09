-- drop database and tables if they exist
drop database if exists hall_of_famers;
drop table if exists players;
drop table if exists teams;
drop table if exists accolades;
drop table if exists seasons;
drop table if exists statis;
drop trigger if exists evaluate_hall_of_fame_stats;

-- create the database
create database hall_of_famers;

-- use the newly created database
use hall_of_famers;
go

-- create the players table
create table players (
    player_id int primary key,
    team_id int,
    stat_id int,
    accolade_id int,
    player_firstname varchar(50),
    player_lastname varchar(50),
    player_dob date,
    player_position varchar(50),
    player_height float,
    player_weight float,
    player_nationality varchar(100),
    hall_of_fame_eligible varchar(3) default 'no'
);
go

-- create the teams table
create table teams (
    team_id int primary key,
    team_name varchar(50),
    team_city varchar(50),
    team_state varchar(50)
);
go

-- create the seasons table
create table seasons (
    season_id int primary key,
    season_year int,
    season_description varchar(255),
    season_made_playoffs bit
);
go

-- create the accolades table
create table accolades (
    accolade_id int primary key,
    player_id int,
    accolade_mvp_status bit,
    accolade_rookie_of_year smallint,
    accolade_finals_mvp smallint,
    accolade_scoring_title smallint,
    accolade_defensive_poy smallint,
    accolade_championships smallint,
    accolade_olympic_medals varchar(255)
);
go

-- create the stats table
create table statis (
    stat_id int primary key,
    player_id int,
    season_id int,
    stat_points int,
    stat_assists int,
    stat_rebounds int,
    stat_steals int,
    stat_blocks int,
    stat_turnovers int,
    stat_minutes_played int,
    stat_seasons_played int
);
go



-- insert data into the teams table
insert into teams (team_id, team_name, team_city, team_state) values
(1, 'Lakers', 'Los Angeles', 'California'),
(2, 'Bulls', 'Chicago', 'Illinois'),
(3, 'Celtics', 'Boston', 'Massachusetts'),
(4, 'Warriors', 'San Francisco', 'California'),
(5, 'Heat', 'Miami', 'Florida');
go

-- insert data into the seasons table
insert into seasons (season_id, season_year, season_description, season_made_playoffs) values
(5, 2021, '2020-2021 NBA Season', 1),
(4, 2020, '2019-2020 NBA Season', 1),
(3, 2019, '2018-2019 NBA Season', 1),
(2, 2018, '2017-2018 NBA Season', 1),
(1, 2017, '2016-2017 NBA Season', 1);
go

-- insert data into the accolades table
insert into accolades (accolade_id, player_id, accolade_mvp_status, accolade_rookie_of_year, accolade_finals_mvp, accolade_scoring_title, accolade_defensive_poy, accolade_championships, accolade_olympic_medals) values
(1, 1, 1, 0, 1, 0, 1, 3, 2),
(2, 2, 0, 1, 0, 1, 0, 1, 1),
(3, 3, 1, 0, 1, 0, 0, 2, 1),
(4, 4, 0, 0, 0, 0, 1, 4, 3),
(5, 5, 1, 1, 1, 1, 1, 2, 1);
go

-- insert data into the stats table
insert into statis (stat_id, player_id, season_id, stat_points, stat_assists, stat_rebounds, stat_steals, stat_blocks, stat_turnovers, stat_minutes_played, stat_seasons_played) values
(1, 1, 1, 300, 20, 60, 50, 100,100, 500, 1),
(2, 2, 2, 2300, 700, 500, 150, 90, 250, 2300, 2),
(3, 3, 3, 14000, 100, 1000, 1500, 95, 200, 4000, 6),
(4, 4, 4, 16000, 3000, 5000, 200, 110, 280, 8000, 11),
(5, 5, 5, 18000, 8000, 3000, 1000, 1000, 500, 14000, 20);
go

-- insert data into the players table
insert into players (player_id, team_id, stat_id, accolade_id, player_firstname, player_lastname, player_dob, player_position, player_height, player_weight, player_nationality) values
(1, 1, 1, 1, 'John', 'Doe', '1990-01-15', 'Guard', 6.3, 190, 'USA'),
(2, 2, 2, 2, 'Mike', 'Smith', '1989-03-22', 'Forward', 6.7, 210, 'USA'),
(3, 3, 3, 3, 'James', 'Johnson', '1991-07-18', 'Center', 6.10, 240, 'USA'),
(4, 4, 4, 4, 'Robert', 'Brown', '1992-09-30', 'Forward', 6.8, 220, 'USA'),
(5, 5, 5, 5, 'David', 'Miller', '1988-12-05', 'Guard', 6.2, 185, 'USA');
go

--keys
begin try
    alter table players drop constraint fk_players_teams;
end try
begin catch
    print 'constraint fk_players_teams does not exist or could not be dropped.';
end catch;

begin try
    alter table players drop constraint fk_players_statis;
end try
begin catch
    print 'constraint fk_players_statis does not exist or could not be dropped.';
end catch;

begin try
    alter table players drop constraint fk_players_accolades;
end try
begin catch
    print 'constraint fk_players_accolades does not exist or could not be dropped.';
end catch;

begin try
    alter table accolades drop constraint fk_accolades_players;
end try
begin catch
    print 'constraint fk_accolades_players does not exist or could not be dropped.';
end catch;

begin try
    alter table statis drop constraint fk_statis_players;
end try
begin catch
    print 'constraint fk_statis_players does not exist or could not be dropped.';
end catch;

begin try
    alter table statis drop constraint fk_statis_seasons;
end try
begin catch
    print 'constraint fk_statis_seasons does not exist or could not be dropped.';
end catch;

alter table players 
add constraint fk_players_teams foreign key (team_id) references teams(team_id);

alter table players
add constraint fk_players_statis foreign key (stat_id) references statis(stat_id);

alter table players
add constraint fk_players_accolades foreign key (accolade_id) references accolades(accolade_id);

alter table accolades
add constraint fk_accolades_players foreign key (player_id) references players(player_id);

alter table statis
add constraint fk_statis_players foreign key (player_id) references players(player_id);

alter table statis
add constraint fk_statis_seasons foreign key (season_id) references seasons(season_id);


-- create trigger

create trigger evaluate_hall_of_fame_stats
on statis
after insert, update
as
begin
    declare @player_id int;
    declare @stat_points int;
    declare @stat_assists int;
    declare @stat_blocks int;
    declare @stat_seasons_played int;
    declare @stat_rebounds int;
    declare @accolade_mvp_status bit;
    declare @accolade_rookie_of_year smallint;
    declare @accolade_finals_mvp smallint;
    declare @accolade_scoring_title smallint;
    declare @accolade_defensive_poy smallint;
    declare @accolade_championships smallint;
    declare @accolade_olympic_medals int;
    declare @hall_of_fame_status varchar(3);

    select @player_id = i.player_id
    from inserted i;

    if @player_id is null
    begin
        return;
    end

    select @stat_points = s.stat_points,
           @stat_assists = s.stat_assists,
           @stat_blocks = s.stat_blocks,
           @stat_seasons_played = s.stat_seasons_played,
           @stat_rebounds = s.stat_rebounds
    from statis s
    where s.player_id = @player_id;

    select @accolade_mvp_status = a.accolade_mvp_status,
           @accolade_rookie_of_year = a.accolade_rookie_of_year,
           @accolade_finals_mvp = a.accolade_finals_mvp,
           @accolade_scoring_title = a.accolade_scoring_title,
           @accolade_defensive_poy = a.accolade_defensive_poy,
           @accolade_championships = a.accolade_championships,
           @accolade_olympic_medals = coalesce(a.accolade_olympic_medals, 0)
    from accolades a
    where a.player_id = @player_id;

    -- Default hall of fame status to 'no'
    set @hall_of_fame_status = 'no';

    -- Calculate hall of fame eligibility
    if @stat_points >= 20000 and 
       @stat_assists >= 5000 and 
       @stat_blocks >= 1000 and 
       @stat_seasons_played >= 10 and 
       @stat_rebounds >= 5000 and 
       (@accolade_mvp_status >= 1 or 
        @accolade_rookie_of_year >= 1 or 
        @accolade_finals_mvp >= 1 or 
        @accolade_scoring_title >= 1 or 
        @accolade_defensive_poy >= 1 or 
        @accolade_championships >= 0 or 
        @accolade_olympic_medals >= 0)
    begin
        set @hall_of_fame_status = 'yes';
    end

    -- Update player's hall of fame eligibility
    update players
    set hall_of_fame_eligible = @hall_of_fame_status
    where player_id = @player_id;
end;
go

update statis
set stat_points = 22000, stat_assists = 6000, stat_blocks = 1100, stat_seasons_played = 11, stat_rebounds = 6000
where player_id = 1;
go

select * from players;
