<template>
  <div class="detail container-fluid">
    <div class="row">
      <div class="col-12">
        <h2>Informacje podstawowe</h2>
        <b-form-group
          label="Dodatkowe wymagania"
        >
          <plano-editor
            id="interest-instructions-text"
            v-model="session.instructions_for_interest"
            type='classic'
            @change="saveSession()"
          ></plano-editor>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <pill-display 
          v-model="session_areas"
          @input="saveSession()"
          label="Blok programowy"
          color="primary"
          :modalOptions="areaOptions"
          :formatter="areaFormatter"
        ></pill-display>
      </div>
      <div class="col-6">
        <b-form-group
          label="Typ punktu programu"
        >
          <model-select
            id="session-format"
            v-model="session.format_id"
            model="format"
            field="name"
            :multiple="false"
            @change="saveSession()"
            :selectSize="4"
          ></model-select>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Ograniczenia wiekowe">
          <b-form-input id="session-age-restrictions" type="text" v-model="session.age_restrictions" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <pill-display
          v-model="session.label_list"
          @input="saveSession()"
          label="Admin Labels"
          color="info"
          :modalOptions="sessionLabelsOptions"
        ></pill-display>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Content warning">
          <b-textarea id="session-content-warning" v-model="session.content_warning" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Ułatwienia dostępu">
          <b-textarea id="session-accessibility" v-model="session.accessibility" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h3>Dostępność</h3>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 10-11">
          <b-form-input id="session-unavailable-10-11" type="text" v-model="session.unavailable_10_11" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 16-17">
          <b-form-input id="session-unavailable-16-17" type="text" v-model="session.unavailable_16_17" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 11-12">
          <b-form-input id="session-unavailable-11-12" type="text" v-model="session.unavailable_11_12" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 17-18">
          <b-form-input id="session-unavailable-17-18" type="text" v-model="session.unavailable_17_18" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 12-13">
          <b-form-input id="session-unavailable-12-13" type="text" v-model="session.unavailable_12_13" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 18-19">
          <b-form-input id="session-unavailable-18-19" type="text" v-model="session.unavailable_18_19" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 13-14">
          <b-form-input id="session-unavailable-13-14" type="text" v-model="session.unavailable_13_14" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 19-20">
          <b-form-input id="session-unavailable-19-20" type="text" v-model="session.unavailable_19_20" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 14-15">
          <b-form-input id="session-unavailable-14-15" type="text" v-model="session.unavailable_14_15" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 20-21">
          <b-form-input id="session-unavailable-20-21" type="text" v-model="session.unavailable_20_21" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Niedostępność 15-16">
          <b-form-input id="session-unavailable-15-16" type="text" v-model="session.unavailable_15_16" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group label="Niedostępność 21-22">
          <b-form-input id="session-unavailable-21-22" type="text" v-model="session.unavailable_21_22" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Niedostępność - uwagi">
          <b-form-textarea id="session-unavailability-notes" type="text" v-model="session.unavailability_notes" @blur="saveSession()"></b-form-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Współprowadzenie">
          <b-form-input id="session-participant-notes" type="text" v-model="session.participant_notes" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Wymagania techniczne">
          <b-textarea id="session-tech-notes" v-model="session.tech_notes" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Czy punkt programu był prezentowany wcześniej?">
          <b-textarea id="session-is-reused" v-model="session.is_reused" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Doświadczenie programowe">
          <b-textarea id="session-experience" v-model="session.experience" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Organizacja fandomowa">
          <b-textarea id="session-fandom-organization" v-model="session.fandom_organization" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Dopuszczam uczestnictwo w panelach o tematyce">
          <b-textarea id="session-open-for-panel-participation" v-model="session.open_for_panel_participation" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Zgoda na rejestrację audio/video" class="form-inline mb-4">
          <span>Nie</span>
          <b-form-checkbox id="session-streaming-allowed" inline switch v-model="session.streaming_allowed" @change="saveSession()">Tak</b-form-checkbox>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Zgłoszony inny punkt programu?">
          <b-textarea id="session-other-proposals" v-model="session.other_proposals" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Abstrakt">
          <b-form-input id="session-abstract-url" type="text" v-model="session.abstract_url" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h3>RPG</h3>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="System">
          <b-form-input id="session-rpg-system" type="text" v-model="session.rpg_system" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Wymagana znajomość systemu/mechaniki?" class="form-inline mb-4">
          <span>Nie</span>
          <b-form-checkbox id="session-knowledge-needed" inline switch v-model="session.rpg_knowledge_needed" @change="saveSession()">Tak</b-form-checkbox>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Dla początkujących graczy?" class="form-inline mb-4">
          <span>Nie</span>
          <b-form-checkbox id="session-rpg-for-beginners" inline switch v-model="session.rpg_for_beginners" @change="saveSession()">Tak</b-form-checkbox>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Liczba graczy">
          <b-form-input id="session-rpg-number-of-players" type="text" v-model="session.rpg_number_of_players" @blur="saveSession()"></b-form-input>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Twardość podejścia">
          <b-form-textarea id="session-rpg-hardness" type="text" v-model="session.rpg_hardness" @blur="saveSession()"></b-form-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h3>Inne</h3>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Session Environment">
          <b-form-radio-group
            id="session-environment"
            stacked
            v-model="session.environment"
            @change="saveSession()"
            v-if="currentSettings && currentSettings.enums"
          >
            <b-form-radio v-for="env in currentSettings.enums.Session.environment" :value="env"  v-bind:key="env">{{SESSION_ENVIRONMENT[env]}}</b-form-radio>
          </b-form-radio-group>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group
          label="Room Setup"
        >
          <model-select
            id="session-room-setup"
            v-model="session.room_set_id"
            model="room_set"
            field="name"
            :multiple="false"
            @change="saveSession()"
            :selectSize="4"
          ></model-select>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Attendee Signup Required" class="form-inline mb-4">
          <span>No</span>
          <b-form-checkbox  id="session-attendee-signup-req" inline switch v-model="session.require_signup" @change="saveSession()">Yes</b-form-checkbox>
          <label :class="['ml-2', {'text-muted': !session.require_signup}]">Jeśli tak, maksymalna liczba miejsc:
            <ValidationProvider v-slot="validationCtx" rules="min_value:1">
              <b-form-input
                id="session-max-signups"
                type="number"
                class="ml-1"
                :disabled="!session.require_signup"
                v-model="session.audience_size"
                @blur="saveValidatedSession(validationCtx)"
                :state="getValidationState(validationCtx)"
                ></b-form-input>
              <b-form-invalid-feedback>{{ validationCtx.errors[0] }}</b-form-invalid-feedback>
            </ValidationProvider>
          </label>
        </b-form-group>
      </div>
      <div class="col-6">
        <pill-display 
          v-model="session.tag_list"
          @input="saveSession()"
          label="Public Tags"
          color="warning"
          :modalOptions="sessionTagsOptions"
        ></pill-display>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel } from '@/store/session.store'
import modelUtilsMixin from '@/store/model_utils.mixin';
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import PlanoEditor from '@/components/plano_editor';
import { ValidationProvider, extend } from 'vee-validate';
import { min_value } from 'vee-validate/dist/rules'
import { SESSION_ENVIRONMENT } from '@/constants/strings'
import {minorsParticipationMixin} from './minors_participation.mixin';
import { ageRestrictionMixin } from './age_restriction.mixin';
import PillDisplay from '@/components/pill_display.vue';
import { tagsMixin } from '@/store/tags.mixin';
import { areaMixin } from '@/store/area.mixin';

extend('min_value', {
  ...min_value,
  message: "This value can't be less than 1"
  })

export default {
  name: "SessionEdit",
  components: {
    ModelSelect,
    ModelTags,
    PlanoEditor,
    ValidationProvider,
    PillDisplay,
  },
  mixins: [
    modelUtilsMixin,
    minorsParticipationMixin,
    ageRestrictionMixin,
    tagsMixin,
    areaMixin,
  ],
  data: () => ({
    editable: false,
    saving: false,
    SESSION_ENVIRONMENT,
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel)
    },
    session_areas: {
      get() {
        let res = Object.values(this.session.session_areas).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
              obj.area_id
          )
        )

        return res
      },
      set(val) {
        let existingAreas = Object.values(this.session.session_areas)
        let newAreas = val;
        let areasForSaving = [];
        for (let area of newAreas) {
          let existing = existingAreas.find(r => r.area.id === area);
          if(existing) {
            areasForSaving.push(this.buildArea(existing));
          } else {
            areasForSaving.push({area_id: area})
          }
        }
        for (let area of existingAreas) {
          if(!newAreas.includes(area.area.id)) {
            areasForSaving.push({...this.buildArea(area), _destroy: 1})
          }
        }

        this.session.session_areas_attributes = areasForSaving
      }
    },
  },
  methods: {
    edit() {
      this.editable = true
    },
    buildArea(v) {
      return {
        id: v.id,
        area_id: v.area.id
      }
    },
    saveSession() {
      this.save_model(sessionModel, this.session)
    },
    saveValidatedSession({dirty, valid=null}) {
      if(dirty && valid) {
        this.save_model(sessionModel, this.session)
      }
    },
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },
  }
}
</script>

<style>

</style>
