<template>
  <div class="d-flex" v-if="selected">
    <div class="d-flex flex-column w-50 p-2 mr-3">
      <div>
        <h5>Ogólne</h5>
        <dl>
          <dt>Współprowadzenie</dt>
          <dd class="ml-2 font-italic" v-html="session.participant_notes"></dd>
          <dt v-if="session.instructions_for_interest">Dodatkowe wymagania lub uwagi</dt>
          <dd v-if="session.instructions_for_interest" class="ml-2 font-italic">{{ session.instructions_for_interest }}</dd>
          <dt v-if="session.team_size">Liczba osób w drużynie?</dt>
          <dd v-if="session.team_size" class="ml-2 font-italic">{{ session.team_size }}</dd>
          <dt v-if="session.tech_notes">Wymagania techniczne</dt>
          <dd v-if="session.tech_notes" class="ml-2 font-italic">{{ session.tech_notes }}</dd>
          <dt>Content warning</dt>
          <dd class="ml-2 font-italic">{{ session.content_warning }}</dd>
          <dt>Ograniczenia wiekowe</dt>
          <dd class="ml-2 font-italic">{{ session.age_restrictions }}</dd>
          <dt>Ułatwienia dostępu</dt>
          <dd class="ml-2 font-italic">{{ session.accessibility }}</dd>
        </dl>
      </div>
      <div v-if="session.rpg_system">
        <h5>Sesja RPG</h5>
        <dl>
          <dt>System/mechanika</dt>
          <dd class="ml-2 font-italic">{{ session.rpg_system }}</dd>
          <dt>Konieczna znajomość systemu/mechaniki?</dt>
          <dd class="ml-2 font-italic">{{ session.rpg_knowledge_needed ? 'Tak' : 'Nie' }}</dd>
          <dt>Dla początkujących graczy?</dt>
          <dd class="ml-2 font-italic">{{ session.rpg_for_beginners ? 'Tak' : 'Nie' }}</dd>
          <dt>Min/max osób</dt>
          <dd class="ml-2 font-italic">{{ session.rpg_number_of_players }}</dd>
          <dt>Twardość podejścia</dt>
          <dd class="ml-2 font-italic">{{ session.rpg_hardness }}</dd>
        </dl>
      </div>
      <div>
        <h5>Inne</h5>
        <dl>
          <dt>Czy punkt programu był prezentowany wcześniej?</dt>
          <dd v-if="session.is_reused" class="ml-2 font-italic">{{ session.is_reused }}</dd>
          <dd v-if="!session.is_reused" class="ml-2 font-italic text-muted">Nie</dd>
          <dt>Doświadczenie programowe</dt>
          <dd v-if="session.experience" class="ml-2 font-italic">{{ session.experience }}</dd>
          <dd v-if="!session.experience" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Organizacja fandomowa</dt>
          <dd v-if="session.fandom_organization" class="ml-2 font-italic">{{ session.fandom_organization }}</dd>
          <dd v-if="!session.fandom_organization" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Dopuszczam uczestnictwo w panelach o tematyce</dt>
          <dd v-if="session.open_for_panel_participation" class="ml-2 font-italic">{{ session.open_for_panel_participation }}</dd>
          <dd v-if="!session.open_for_panel_participation" class="ml-2 font-italic text-muted">Nie</dd>
          <dt>Zgoda na rejestrację audio/wideo proponowanej atrakcji programowej?</dt>
          <dd class="ml-2 font-italic">{{ session.streaming_allowed ? 'Tak' : 'Nie' }}</dd>
          <dt v-if="session.abstract_url">Abstraktu referatu</dt>
          <dd v-if="session.abstract_url" class="ml-2 font-italic"><a :href="session.abstract_url">Link</a></dd>
          <dt>Zgłoszony inny punkt programu?</dt>
          <dd class="ml-2 font-italic">{{ session.other_proposals }}</dd>
        </dl>
      </div>
    </div>
    <div class="d-flex flex-column w-50 p-2">
      <div>
        <h5>Niedostępność godzinowa</h5>
        <dl>
          <dt>Niedostępność 10-11</dt>
          <dd v-if="session.unavailable_10_11" class="ml-2 font-italic">{{ session.unavailable_10_11 }}</dd>
          <dd v-if="!session.unavailable_10_11" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 11-12</dt>
          <dd v-if="session.unavailable_11_12" class="ml-2 font-italic">{{ session.unavailable_11_12 }}</dd>
          <dd v-if="!session.unavailable_11_12" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 12-13</dt>
          <dd v-if="session.unavailable_12_13" class="ml-2 font-italic">{{ session.unavailable_12_13 }}</dd>
          <dd v-if="!session.unavailable_12_13" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 13-14</dt>
          <dd v-if="session.unavailable_13_14" class="ml-2 font-italic">{{ session.unavailable_13_14 }}</dd>
          <dd v-if="!session.unavailable_13_14" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 14-15</dt>
          <dd v-if="session.unavailable_14_15" class="ml-2 font-italic">{{ session.unavailable_14_15 }}</dd>
          <dd v-if="!session.unavailable_14_15" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 15-16</dt>
          <dd v-if="session.unavailable_15_16" class="ml-2 font-italic">{{ session.unavailable_15_16 }}</dd>
          <dd v-if="!session.unavailable_15_16" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 16-17</dt>
          <dd v-if="session.unavailable_16_17" class="ml-2 font-italic">{{ session.unavailable_16_17 }}</dd>
          <dd v-if="!session.unavailable_16_17" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 17-18</dt>
          <dd v-if="session.unavailable_17_18" class="ml-2 font-italic">{{ session.unavailable_17_18 }}</dd>
          <dd v-if="!session.unavailable_17_18" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 18-19</dt>
          <dd v-if="session.unavailable_18_19" class="ml-2 font-italic">{{ session.unavailable_18_19 }}</dd>
          <dd v-if="!session.unavailable_18_19" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 19-20</dt>
          <dd v-if="session.unavailable_19_20" class="ml-2 font-italic">{{ session.unavailable_19_20 }}</dd>
          <dd v-if="!session.unavailable_19_20" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 20-21</dt>
          <dd v-if="session.unavailable_20_21" class="ml-2 font-italic">{{ session.unavailable_20_21 }}</dd>
          <dd v-if="!session.unavailable_20_21" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Niedostępność 21-22</dt>
          <dd v-if="session.unavailable_21_22" class="ml-2 font-italic">{{ session.unavailable_21_22 }}</dd>
          <dd v-if="!session.unavailable_21_22" class="ml-2 font-italic text-muted">Brak</dd>
          <dt>Dodatkowe uwagi o niedostępności</dt>
          <dd v-if="session.unavailability_notes" class="ml-2 font-italic">{{ session.unavailability_notes }}</dd>
          <dd v-if="!session.unavailability_notes" class="ml-2 font-italic text-muted">Brak</dd>
        </dl>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel as model} from '@/store/session.store'
import { modelMixinNoProp } from '@/mixins';

export default {
  name: "ViewCopernicon",
  props: {
    session: {
      required: true
    },
  },
  mixins: [
    modelMixinNoProp,
  ],
  data: () => ({
    model,
    loading: false
  }),
  methods: {
    load() {
      this.clear();
      this.loading = true;
      this.fetch({session_id: this.session.id}).then(() => {
        this.loading = false;
      })
    }
  },
  watch: {
    session(newSession, oldSession) {
      if (newSession) {
        if ((oldSession && oldSession.id !== newSession.id) || !oldSession) {
          this.load();
        }
      }
    }
  },
  mounted() {
    this.load();
  }
}
</script>

<style>

</style>
