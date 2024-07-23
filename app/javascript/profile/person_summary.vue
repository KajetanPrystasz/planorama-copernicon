<template>
<div :class="['container-fluid', {'my-3': !readOnly}]" v-if="selected">
  <div class="row">
    <div class="col-8">
      <h3>{{selected.custom_published_name ? selected.custom_published_name : selected.full_name }}<edit-button v-b-modal.person-top-modal v-if="!readOnly"></edit-button></h3>
      <div>
        Zaimki: <em>{{selected.pronouns}}</em>
      </div>
      <div>
        Chętny do moderowania sesji: <em>{{willing_to_moderate}}</em>
      </div>
      <div>
        Głowny email: <em v-if="selected.primary_email">{{selected.primary_email.email}}</em>
      </div>
    </div>
    <div class="d-flex flex-column col-4 align-items-end">
        <small>Ostatni login: {{formatLocaleDate(selected.current_sign_in_at)}}</small>
        <b-button v-if="currentUserIsAdmin && airmeetEnabled" variant="warning" :disabled="!selected.integrations.airmeet" @click="resyncAirmeet" class="mt-2">Zakończono ponowną synchronizację Airmeet</b-button>
    </div>
  </div>
  <person-edit-modal id="person-top-modal" body-class="formscroll" :person="selected" :data="editData" :validate="true">
    <template #modal-title>Edytuj profil - {{ selected.custom_published_name ? selected.custom_published_name : selected.full_name }}</template>
    <template #default="{fields}">
      <validation-provider
        name="Name"
        rules="required"
        v-slot="{errors, dirty, validated, valid}">
        <b-form-group label="Imię">
          <b-form-input 
            type="text" 
            v-model="fields.name" 
            aria-describedby="name-invalid-feedback"
            :state="dirty || validated ? (valid ? null : false) : null"
            required>
          </b-form-input>
          <b-form-invalid-feedback id="name-invalid-feedback">{{errors[0]}}</b-form-invalid-feedback>
        </b-form-group>
      </validation-provider>
      <validation-provider
        name="Surname"
        rules="required"
        v-slot="{errors, dirty, validated, valid}">
        <b-form-group label="Nazwisko">
          <b-form-input
            type="text" 
            v-model="fields.surname" 
            aria-describedby="surname-invalid-feedback"
            :state="dirty || validated ? (valid ? null : false) : null"
            required>
          </b-form-input>
          <b-form-invalid-feedback id="surname-invalid-feedback">{{errors[0]}}</b-form-invalid-feedback>
        </b-form-group>
      </validation-provider>
      <validation-provider name="Pseudonim">
        <b-form-group label="Pseudonim">
          <b-form-input type="text" v-model="fields.pseudonym"></b-form-input>
        </b-form-group>
      </validation-provider>
      <validation-provider name="W programie jako">
        <b-form-group label="W programie jako">
          <b-form-input type="text" v-model="fields.custom_published_name"></b-form-input>
        </b-form-group>
      </validation-provider>
      <validation-provider
        name="Numer telefonu"
        rules="required"
        v-slot="{errors, dirty, validated, valid}">
        <b-form-group label="Numer telefonu">
          <b-form-input
          type="text"
          v-model="fields.phone_number"
          aria-describedby="phone-number-invalid-feedback"
          :state="dirty || validated ? (valid ? null : false) : null"
          required>
          ></b-form-input>
          <b-form-invalid-feedback id="phone-number-invalid-feedback">{{errors[0]}}</b-form-invalid-feedback>
        </b-form-group>
      </validation-provider>
      <validation-provider name="Ukończone 18 lat w chwili rozpoczęcia konwentu">
        <b-form-group>
          <b-form-checkbox switch v-model="fields.of_age_at_convention_time">Ukończone 18 lat w chwili rozpoczęcia konwentu</b-form-checkbox>
        </b-form-group>
      </validation-provider>
      <validation-provider name="Zaimki">
        <b-form-group label="Zaimki">
          <b-form-input type="text" v-model="fields.pronouns"></b-form-input>
        </b-form-group>
      </validation-provider>
      <validation-provider name="Willing to moderate">
        <b-form-group>
          <b-form-checkbox switch v-model="fields.willing_to_moderate">Chętny do moderowania sesji</b-form-checkbox>
        </b-form-group>
      </validation-provider>
    </template>
  </person-edit-modal>
</div>
</template>

<script>
const { DateTime } = require("luxon");
import EditButton from '@/components/edit_button';
import PersonEditModal from './person_edit_modal';
import { modelMixinNoProp } from '@/store/model.mixin';
import { personEndpoints, personModel } from '@/store/person.store';
import {PERSON_NEVER_LOGGED_IN} from "@/constants/strings";
import { toastMixin, personSessionMixin } from '@/mixins';
import { airmeetMixin } from '@/integrations/airmeet.mixin';
import {ValidationProvider} from 'vee-validate';
import LoginIntegrations from "@/login/login_integrations.vue";

export default {
  name: "PersonSummary",
  props: {
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    EditButton,
    PersonEditModal,
    ValidationProvider,
    LoginIntegrations
  },
  data: () => ({
    editData: {
      name: null,
      surname: null,
      pseudonym: null,
      custom_published_name: null,
      phone_number: null,
      of_age_at_convention_time: null,
      pronouns: null,
      willing_to_moderate: null
    },
    model: personModel
  }),
  mixins: [
    modelMixinNoProp,
    personSessionMixin,
    toastMixin,
    airmeetMixin
  ],
  computed: {
    willing_to_moderate() {
      return this.selected.willing_to_moderate ? 'Tak' : 'Nie'
    }
  },
  methods: {
    formatLocaleDate(date, config=DateTime.DATETIME_FULL) {
      if(!date)
        return PERSON_NEVER_LOGGED_IN;
      let d = new Date(date)
      return DateTime.fromJSDate(d).toLocaleString(config)
    },
    scrollToBottom() {
      const el = document.getElementsByClassName('formscroll')[0];
      console.log(el, el.scrollTop, el.scrollHeight);
      el.scrollTop = el.scrollHeight
    },
    log(e) {
      console.log(e)
      console.log(this.editData)
    },
    resyncAirmeet() {
      this.toastPromise(this.$store.dispatch('jv/get', `${personEndpoints[personModel]}/${this.selected.id}/resync_airmeet`), "Pomyślnie zaktualizowano dane synchronizacji Airmeet.")
    }
  }
}
</script>

<style>

</style>
