<template>
  <div class="mb-3 scrollable">
    <p class="mt-2">To są raporty tymczasowe.</p>
    <ul>
      <li><router-link to="#participants">Uczestnicy</router-link></li>
      <li><router-link to="#sessions">Sesje</router-link></li>
      <li><router-link to="#conflicts">Konflikty</router-link></li>
      <li><router-link to="#schedule">Harmonogram</router-link></li>
      <li><router-link to="#prog-ops">Operacje programowe</router-link></li>
    </ul>
    <h5><a id="participants"></a>Uczestnicy</h5>
    <ul>
      <li>
        <a href="/report/participant_selections" target="_blank">Wybory uczestników</a><br />
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Sesje i rankingi wybrane przez osoby, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, tytuł sesji, ranking, uwagi dotyczące rankingu, obszary sesji, czy osoba została przypisana (t/n), czy sesja została zaplanowana (t/n)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: dowolna sesja wybrana przez co najmniej jedną osobę<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/participant_availabilities" target="_blank">Dostępności uczestników</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje z zakładki "Dostępność i zainteresowania" osoby (dzienny limit i limit na konferencję, dni/godziny dostępności, specjalne wydarzenia do udziału)<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), dostępności (dni/godziny), limity (dzienny & na konferencję/"globalny"), wyłączenia (specjalne wydarzenia do udziału), uwagi dotyczące dostępności<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/assigned_sessions_by_participant" target="_blank">Przypisane sesje według uczestnika</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People assigned to sessions, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, attendance type, match status, session title, person’s role in the session, has session been scheduled (y/n), tags, admin labels<br />
          <strong><em>Session data included</em></strong>: any session with at least one person assigned as moderator, participant, invisible participant, or reserved<br />
          <strong><em>Person data included</em></strong>: session role of moderator, participant, invisible participant, or reserved
        </p>
      </li>
      ```html
      <li>
        <a href="/report/people_and_submissions" target="_blank">Osoby i zgłoszenia do ankiety</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista przeprowadzonych ankiet, wraz z datą i godziną przesłania, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa, status uczestnika, przeprowadzone ankiety<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: status uczestnika: applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <span v-if="!currentUserIsAdmin" class="text-muted font-italic" title="Nie masz odpowiedniego zestawu uprawnień do uruchomienia tego raportu." v-b-tooltip>Uczestnicy i Osoby do Nieprzypisania</span>
        <a href="/report/participant_do_not_assign_with" target="_blank" v-if="currentUserIsAdmin">Uczestnicy i Osoby do Nieprzypisania</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby, które nie powinny być przypisywane do tych samych sesji, jedna linia na osobę i sesję; dostępne tylko dla użytkowników z uprawnieniami do przeglądania wrażliwych danych<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, tytuł sesji, obszary sesji, nazwy innych osób przypisanych do sesji, nazwy osób, których nie należy przypisywać do tej samej sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy, którzy podali informacje o tym, z kim nie należy ich przypisywać
        </p>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_session_limits" target="_blank">Uczestnicy przekraczający dzienny limit</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na więcej sesji, niż określono w ich dziennym i/lub całkowitym limicie, jedna linia na osobę i przekroczony limit dzienny/całkowity<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, dzień (w tym poszczególne dni i &quot;Wszystkie&quot; dla limitu całkowitego), liczba sesji (liczba przypisanych sesji), limit osoby (określony w zakładce &quot;Dostępność i zainteresowania&quot;)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy przekraczający określony dzienny lub całkowity limit
        </p>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_con_session_limits" target="_blank">Uczestnicy przekraczający limit konferencji</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na więcej sesji, niż pozwala konferencja, z pewnymi wyjątkami dotyczącymi formatu sesji, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, liczba sesji (liczba przypisanych sesji), limit konferencji (maksymalna liczba sesji dozwolona przez konferencję, czyli 6)<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje oprócz tych w formatach: autografy, spotkania, czytania, próby, rozmowy przy stole<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy przekraczający limit konferencji 6 sesji, bez uwzględnienia wyjątków formatu
        </p>
      </li>
      <li>
        <a href="/report/session_reports/non_accepted_on_schedule" target="_blank">Niezaakceptowani uczestnicy na zaplanowanych sesjach</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People with participant status other than &quot;accepted&quot; assigned to scheduled sessions, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session title, area(s) of session, tags, admin labels<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants, invisible participants with a participant status that is not &quot;accepted&quot; or &quot;not_set&quot;
        </p>
      </li>
      <li>
        <a href="/report/session_reports/invited_accepted_not_scheduled" target="_blank">Zaproszeni i zaakceptowani, którzy nie są na liście sesji</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby o statusie uczestnika zaakceptowany, zaproszony lub oczekujący na zaproszenie, które nie są przypisane do żadnych sesji, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, status uczestnika, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), biogram osoby<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: osoby o statusie uczestnika zaakceptowany, zaproszony lub oczekujący na zaproszenie, które nie są przypisane do żadnej sesji, lub które są przypisane jako niewidoczni uczestnicy lub zarezerwowani na jednej lub więcej sesji
        </p>
      </li>
      <li>
        <a href="/report/people_reports/record_stream_permissions" target="_blank">Uprawnienia sesji uczestnika (nagrywanie, przesyłanie strumieniowe i ograniczenia demograficzne)</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista uczestników wraz z ich uprawnieniami do nagrywania i przesyłania strumieniowego oraz wyłączeniami, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa, status uczestnika, uprawnienia do przesyłania strumieniowego, wyłączenia przesyłania strumieniowego, uprawnienia do nagrywania, wyłączenia nagrywania, tematy do unikania, harmonogram<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/people_reports/moderators" target="_blank">Uczestnicy, którzy moderują co najmniej jedną sesję</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby pełniące rolę moderatora co najmniej w jednej sesji, wraz z informacjami o sesji, jedna linia na osobę i sesję<br />
          <strong><em>Pola</em></strong>: Nazwa osoby, opublikowana nazwa, główny adres e-mail, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), status uczestnika, tytuł sesji, środowisko sesji<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy
        </p>
      </li>
      <li>
        <a href="/report/people_reports/social_media" target="_blank">Uczestnicy posiadający media społecznościowe</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje o mediach społecznościowych uczestników, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, typ uczestnictwa, status uczestnika, biogram uczestnika, blok mediów społecznościowych uczestnika<br />
          <strong><em>Dane sesji uwzględnione</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osoby uwzględnione</em></strong>: moderatorzy i uczestnicy przypisani do co najmniej jednej zaplanowanej sesji
        </p>
      </li>
      <li>
      <a href="/report/people_reports/mis_matched_envs" target="_blank">Uczestnicy z niezgodnymi środowiskami sesji i typami uczestnictwa</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Uczestnicy, których typ uczestnictwa nie odpowiada środowisku sesji, do których są przypisani, jeden wiersz na uczestnika i sesję<br />
        <strong><em>Pola</em></strong>: Nazwa opublikowana, podstawowy adres e-mail, typ uczestnictwa, status uczestnika, tytuł sesji, sala sesyjna, czas rozpoczęcia sesji, środowisko sesji<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy i uczestnicy z typem uczestnictwa "wirtualny" przypisani do sesji o środowisku "hybrydowym" lub "osobistym", lub z typem uczestnictwa "osobisty" przypisani do sesji o środowisku "wirtualnym"
      </p>
    </li>
      
    </ul>

    <h5><a id="sessions"></a>Sessions</h5>
    <ul>
      <li>
        <a href="/report/session_selections" target="_blank">Session Selections</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Sesje i rankingi wybrane przez uczestników, jeden wiersz na sesję i osobę<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, nazwa osoby, opublikowana nazwa osoby, status uczestnika, ranking, uwagi dotyczące rankingu, obszar(y) sesji, tagi, etykiety administratora<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie sesje, które wybrała przynajmniej jedna osoba<br />
          <strong><em>Dane osobowe zawarte</em></strong>: status uczestnika: zastosowany, prawdopodobny, zweryfikowany, oczekujący na zaproszenie, zaproszony, zaakceptowany
        </p>
      </li>
      <li>
        <a href="/report/sessions_with_participants" target="_blank">Sessions with Participants</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Sesje z już przypisanymi osobami, jeden wiersz na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, format sesji, obszar(y) sesji, tagi, etykiety administratora, moderatorzy, uczestnicy, rezerwowani, czy sesja została zaplanowana (t/n)<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie sesje z przynajmniej jedną przypisaną osobą<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, rezerwowani
      </p>
      </li>
      <li>
        <a href="/report/session_reports/streamed_and_recorded" target="_blank">Zaplanowane sesje transmitowane i/lub nagrywane na żywo</a>
        <li>
        <a href="/report/session_reports/scheduled_session_no_moderator" target="_blank">Zaplanowane sesje bez przypisanego moderatora</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Zaplanowane sesje bez przypisanego moderatora, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, czas rozpoczęcia sesji, format sesji, przypisane osoby (uczestnicy, niewidoczni uczestnicy), zarezerwowane osoby<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: uczestnicy, niewidoczni uczestnicy, zarezerwowani
        </p>
      </li>
      <li>
        <a href="/report/session_reports/scheduled_session_no_people" target="_blank">Zaplanowane sesje bez uczestników</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Zaplanowane sesje bez przypisanych moderatorów ani uczestników, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, czas rozpoczęcia sesji, sala<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
      <li>
        <a href="/report/session_reports/assigned_sessions_not_scheduled" target="_blank">Sesje z przypisanymi osobami niezaplanowane</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Sesje, które nie są zaplanowane, ale mają przypisane osoby, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, moderatorzy, uczestnicy, niewidoczni uczestnicy<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie niezaplanowane sesje z przynajmniej jedną osobą przypisaną jako moderator, uczestnik i/lub niewidoczny uczestnik<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      </li>
      <li>
  <a href="/report/session_reports/panels_with_too_few_people" target="_blank">Panele z zbyt małą liczbą uczestników</a>
    <p class="ml-2">
      <strong><em>Opis</em></strong>: Zaplanowane sesje (tylko format panelu) z 3 lub mniejszą liczbą przypisanych osób (moderatorzy, uczestnicy), jeden wiersz na sesję<br />
      <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, czas rozpoczęcia sesji, liczba uczestników, dolne ograniczenie liczby uczestników (3), przypisani uczestnicy, moderatorzy<br />
      <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
      <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
    </p>
    </li>
    <li>
      <a href="/report/session_reports/panels_with_too_many_people" target="_blank">Panele z zbyt dużą liczbą uczestników</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Zaplanowane sesje (tylko format panelu) z 6 lub większą liczbą przypisanych osób (moderatorzy, uczestnicy), jeden wiersz na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, czas rozpoczęcia sesji, liczba uczestników, górne ograniczenie liczby uczestników (6), przypisani uczestnicy, moderatorzy<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
        <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
      </p>
    </li>
    <li>
      <a href="/report/session_reports/session_copy_edit_status" target="_blank">Status korekty kopii sesji</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Status skorygowanej kopii każdej sesji, jeden wiersz na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, status sesji, czy sesja została skorygowana (t/n), czy sesja została zaplanowana (t/n), widoczność (widoczna, niewidoczna)<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie sesje
      </p>
    </li>
    <li>
      <a href="/report/session_reports/streamed_and_recorded" target="_blank">Zaplanowane sesje transmitowane i/lub nagrane</a>
      <p class="ml-2">
        <strong><em>Opis</em></strong>: Informacje o transmisji na żywo i nagrywaniu, jeden wiersz na sesję<br />
        <strong><em>Pola</em></strong>: Tytuł sesji, czas rozpoczęcia sesji, sala sesyjna, format sesji, środowisko sesji, czy sesja jest transmitowana na żywo (t/n), czy sesja jest nagrywana (t/n), tagi, etykiety administratora<br />
        <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
      </p>
    </li>
    </ul>

    <h5><a id="conflicts"></a>Konflikty</h5>
    <ul>
      <li>
        <a href="/report/conflict_reports/people_outside_availability" target="_blank">Osoby spoza dostępności</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby zaplanowane na dni/godziny, których nie oznaczyły jako dostępne, jedna linia na osobę i sesję, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, dostępność uczestnika (dni/godziny)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/people_double_booked" target="_blank">Podwójne rezerwacje osób</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do więcej niż jednej zaplanowanej sesji w tym samym czasie, jedna linia na osobę i wystąpienie podwójnej rezerwacji, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, czas, tytuł sesji, obszar(y) sesji, sala, tytuł sesji konfliktu, obszar sesji konfliktu, sala konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/person_exclusion_conflicts" target="_blank">Osoba zaplanowana w konflikcie z wydarzeniem</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do sesji, która odbywa się o tej samej porze co specjalne wydarzenie, na które chcą uczęszczać, jedna linia na wystąpienie konfliktu, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sesja konfliktu (specjalne wydarzenie), czas rozpoczęcia sesji konfliktu (specjalne wydarzenie)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back" target="_blank">Z powrotem do tyłu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do dwóch sesji z rzędu (gdzie druga sesja zaczyna się mniej niż 40 minut po zakończeniu pierwszej), jedna linia na parę sesji, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji 1, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, tytuł sesji 2, obszar(y) sesji 2, czas rozpoczęcia sesji 2, czas trwania sesji 2, sala 2<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back_to_back" target="_blank">Z powrotem do tyłu do tyłu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby przypisane do trzech sesji z rzędu (gdzie jedna sesja zaczyna się mniej niż 40 minut po poprzedniej), jedna linia na zestaw 3 sesji<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, status uczestnika, tytuł sesji 1, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania ses ji, sala, tytuł sesji 2, obszar(y) sesji 2, czas rozpoczęcia sesji 2, czas trwania sesji 2, sala 2, tytuł sesji 3, obszar(y) sesji 3, czas rozpoczęcia sesji 3, czas trwania sesji 3, sala 3<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
      <li>
        <a href="report/conflict_reports/multiple_sessions_in_room" target="_blank">Wiele sesji w jednej sali</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Dwie lub więcej sesji zaplanowane w tej samej sali o tej samej dacie/godzinie, jedna linia na wystąpienie, z wyjątkiem sytuacji, gdy konflikt został oznaczony jako zignorowany<br />
          <strong><em>Pola</em></strong>: Sala, tytuł sesji, tytuł sesji konfliktu, czas rozpoczęcia<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/all_ignored_conflicts" target="_blank">Zignorowane konflikty osób</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Zignorowane konflikty w tych kategoriach: osoby spoza dostępności, podwójne rezerwacje osób, osoba zaplanowana w konflikcie z wydarzeniem, z powrotem do tyłu, jedna linia na zignorowany konflikt<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, imię osoby, typ konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje
        </p>
      </li>
      <li>
        <a href="/report/conflict_reports/all_conflicts" target="_blank">Wszystkie konflikty</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Wszystkie konflikty w tych kategoriach: osoby spoza dostępności, podwójne rezerwacje osób, osoba zaplanowana w konflikcie z wydarzeniem, z powrotem do tyłu, jedna linia na konflikt<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, imię osoby, typ konfliktu<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy
        </p>
      </li>
    </ul>

    <h5><a id="schedule"></a>Harmonogram</h5>
    <ul>
      <li>
        <a href="/report/schedule_by_room_then_time" target="_blank">Harmonogram według sal, a następnie czasu</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Wszystkie zaplanowane sesje, jedna linia na salę i dzień/godzinę<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, czas rozpoczęcia sesji, czas trwania sesji, sala, przypisani uczestnicy, moderatorzy<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/schedule_by_person" target="_blank">Harmonogram według uczestników</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Schedule for each participant, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session title, area(s) of session, tags, admin labels, session start time, room, moderator (y/n), invisible participant (y/n)<br />
          <strong><em>Person data included</em></strong>: moderators, participants, invisible participants
        </p>
      </li>
      <li>
        <a href="/report/schedule_accpetance" target="_blank">Uczestnicy z zatwierdzonymi wersjami roboczymi i ustalonymi harmonogramami</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Osoby z statusem uczestnika, który nie jest odrzucony, odrzucony, ani nie_ustawiony, z informacją, czy i kiedy zatwierdzili swoje wersje robocze i ustalone harmonogramy, z uwagami, jeśli nie zatwierdzili, jedna linia na osobę<br />
          <strong><em>Pola</em></strong>: Imię osoby, opublikowane imię, podstawowy adres e-mail, typ uczestnictwa (stacjonarne, wirtualne, hybrydowe), status uczestnika, zatwierdzenie wersji roboczej, uwagi do wersji roboczej, czas edycji wersji roboczej, zatwierdzenie ustalonego harmonogramu, uwagi do ustalonego harmonogramu, czas edycji ustalonego harmonogramu<br />
          <strong><em>Dane osobowe zawarte</em></strong>: osoby z statusem uczesnika, który nie jest odrzucony, odrzucony, ani nie_ustawiony, w tym osoby nieprzypisane do żadnych sesji
        </p>
      </li>
    </ul>
    <h5><a id="prog-ops"></a>Operacje Programowe</h5>
    <ul>
      <li>
        <a href="/report/session_reports/daily_grid" target="_blank">Codzienny harmonogram</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Informacje o sesjach dla codziennego harmonogramu, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, obszar(y) sesji, tagi, etykiety administratora, format sesji, czas rozpoczęcia sesji, czas trwania sesji, sala sesyjna<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w najnowszym wydaniu<br />
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/back_of_badge" target="_blank">Tylne strony identyfikatorów</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Harmonogram uczestnika do łączenia pocztowego, jeden wiersz na osobę, z zmienną długością wiersza w zależności od liczby przypisanych sesji<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, Tytuł Sesji 1, Skrócony Tytuł Sesji 1 (maksymalnie 30 znaków), Czas Rozpoczęcia Sesji 1, Czas Trwania Sesji 1, Sala Sesji 1, Format Sesji 1, Rola uczestnika w Sesji 1, a następnie powtórz te 7 kolumn sesji według potrzeb<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje ze statusem "przejrzane" lub "zmienione"<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy, niewidoczni uczestnicy z typem uczestnictwa "osobiście" lub "hybrydowo"
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/sign_up_sessions" target="_blank">Sesje wymagające rejestracji uczestników</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Maksymalna liczba uczestników w sesjach wymagających rejestracji, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, opis sesji, sala sesji, czas rozpoczęcia sesji, czas trwania sesji, format sesji, uczestnicy, środowisko sesji, maksymalna liczba uczestników<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w najnowszym wydaniu<br />
        </p>
      </li>
      <li>
        <a href="/report/session_reports/session_needs" target="_blank">Wymagania sesji</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Session setup requirements, one line per session<br />
          <strong><em>Fields</em></strong>: Session title, session start time, duration, session room, session environment, is session livestreamed (y/n), is session recorded (y/n), session format, session area(s), tags, admin labels, required room features&#8725;services, tech&#8725;hotel notes, room setup<br />
          <strong><em>Session data included</em></strong>: all sessions with a time and place that are not dropped<br />
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/session_minors" target="_blank">Sesje i nieletni uczestnicy</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Uczestnictwo nieletnich i ograniczenia wiekowe uczestników, jeden wiersz na sesję<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, tagi, etykiety administratora, opis sesji, czas rozpoczęcia sesji, sala sesji, ograniczenie wiekowe uczestnika, uczestnictwo nieletnich<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie zaplanowane sesje<br />
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/room_signs" target="_blank">Dane do tablic informacyjnych na sali do łączenia pocztowego</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Dane do tablic informacyjnych na sali do łączenia pocztowego, jeden wiersz na salę i dzień tygodnia<br />
          <strong><em>Pola</em></strong>: Sala, dzień tygodnia, sesje (tytuł, tagi, etykiety administratora, czas rozpoczęcia, opis, moderatorzy, uczestnicy)<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w najnowszym wydaniu<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/table_tents" target="_blank">Dane do stołków informacyjnych do łączenia pocztowego</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Dane do stołków informacyjnych do łączenia pocztowego, jeden wiersz na sesję i uczestnika<br />
          <strong><em>Pola</em></strong>: Tytuł sesji, opublikowana nazwa, opis sesji, uwagi zaplanowanego uczestnika, moderatorzy i ich zaimki, uczestnicy i ich zaimki<br />
          <strong><em>Dane sesji zawarte</em></strong>: opublikowane sesje w najnowszym wydaniu, o środowisku "osobiście" lub "hybrydowym"<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy, uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/program_ops_reports/virtual_people" target="_blank">E-maile uczestników i sesje wirtualne</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista e-maili moderatorów i uczestników opublikowanych sesji, z informacją, czy są przypisani do jakiejkolwiek sesji o środowisku wirtualnym, jeden wiersz na uczestnika<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, nazwa, czy osoba jest przypisana do sesji wirtualnej (t/n), główny e-mail, inne e-maile<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje w najnowszym wydaniu<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy i uczestnicy
        </p>
      </li>
      <li>
        <a href="/report/integrations_reports/airmeet_magic_link" target="_blank">Linki magiczne Airmeet</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Linki do wejścia każdego uczestnika (prelegenta) do Airmeet, jeden wiersz na osobę. Do stosowania w przypadku nagłej obsługi klienta.<br />
          <strong><em>Pola</em></strong>: Opublikowana nazwa, główny e-mail, link magiczny Airmeet<br />
          <strong><em>Dane osobowe zawarte</em></strong>: wszyscy moderatorzy i uczestnicy przypisani do sesji wirtualnych
        </p>
      </li>
      <li>
        <a href="/report/integrations_reports/airmeet_diffs" target="_blank">Różnice Airmeet</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Zmiany w informacjach osobowych od ostatniej synchronizacji (ręcznej lub automatycznej) z Airmeet, jeden wiersz na zmianę<br />
          <strong><em>Pola</em></strong>: Czas ostatniej synchronizacji, czas ostatniej aktualizacji danej osoby, e-mail Airmeet, co się zmieniło, z czego, na co<br />
          <strong><em>Dane sesji zawarte</em></strong>: wszystkie opublikowane sesje o środowisku "wirtualnym", w najnowszym wydaniu<br />
          <strong><em>Dane osobowe zawarte</em></strong>: moderatorzy i uczestnicy przypisani do opublikowanych sesji wirtualnych, których opublikowana nazwa, e-mail lub biogram zmieniły się od ostatniej synchronizacji z Airmeet
        </p>
      </li>
    </ul>
    <div style="clear: both; height: 5rem;">&nbsp;</div>
        <span v-if="!currentUserIsAdmin" class="text-muted font-italic" title="You do not have the right set of permissions to run this report." v-b-tooltip>User Privileges</span>
        <a href="/report/program_ops_reports/user_privileges" target="_blank" v-if="currentUserIsAdmin">User Privileges</a>
        <p class="ml-2">
          <strong><em>Opis</em></strong>: Lista logowań (główny e-mail), jeden wiersz na osobę<br />
          <strong><em>Pola</em></strong>: Główny e-mail, opublikowana nazwa, lista ról, ostatnio zalogowany(a) o<br />
          <strong><em>Dane osobowe zawarte</em></strong>: wszystkie osoby z przypisaną rolą lub personelem i&#8725;lub administratorem
        </p>
  </div>
</template>

<script>
import personSessionMixin from '@/auth/person_session.mixin'

export default {
  name: "ReportsScreen",
  mixins: [
    personSessionMixin
  ]
}
</script>

<style>

</style>
