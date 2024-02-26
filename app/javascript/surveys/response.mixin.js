import { utils } from "jsonapi-vuex"
import { submissionModel, questionModel, responseModel as model } from "@/store/survey"
import { PATCH_FIELDS} from "@/store/model.store"
import { mapActions, mapState, mapMutations } from "vuex"
import { NEW_RESPONSE } from "@/store/survey";
import { personSessionMixin } from "@/mixins";

export const responseMixin = {
  mixins: [personSessionMixin],
  data: () => ({
  }),
  computed: {
    ...mapState(['previewMode']),
  },
  methods: {
    ...mapMutations({
      mergeRecords: 'jv/mergeRecords',
      newResponse: NEW_RESPONSE
    }),
    ...mapActions({
      patch: PATCH_FIELDS,
    }),
    getExistingResponse(relationships) {
      let existingResponses = this.$store.getters['jv/get']({_jv: {
        type: model,
      }}, `$[?(@.question.id=='${relationships.question.data.id}' && @.submission.id=='${relationships.submission.data.id}')]`)
      // console.log('existing responses', existingResponses)
      return Object.values(existingResponses)[0]
    },
    getResponse(question, selectedSubmission) {
      // console.debug('getting response...')
      if (!question || !selectedSubmission) {
        // console.debug('missing one of question or selectedSubmission', this.question, this.selectedSubmission)
        return undefined;
      }
      let relationships = {
        question: {
          data: {
            id: question.id,
            type: questionModel
          }
        },
        submission: {
          data: {
            id: selectedSubmission.id,
            type: submissionModel
          }
        }
      }
      let text = '';
      let answers = []
      const socialmedia = {
        twitter: null, facebook: null, linkedin: null,
        twitch: null, youtube: null, instagram: null,
        tiktok: null, other: null, website: null,
        bsky: null, fediverse: null
      }
      // first check for a linked field
      // console.debug("now i have both", this.question, this.selectedSubmission)
      let existingResponse = this.getExistingResponse(relationships)
      if (existingResponse?.id) {
        return utils.deepCopy(existingResponse)
      } else if (question.linked_field) {
        // get the relevant linked data and use that instead
        const fieldName = question.linked_field.split(".")[1] // assuming only one dot. is this bad?
        if (['singlechoice', 'yesnomaybe', 'boolean', 'attendance_type', 'dropdown'].includes(question.question_type)) {
          answers = [this.currentUser[fieldName]]
        } else if (question.question_type === 'multiplechoice') {
          answers = this.currentUser[fieldName]
        } else if (question.question_type === 'socialmedia') {
          socialmedia.twitter = this.currentUser.twitter
          socialmedia.facebook = this.currentUser.facebook
          socialmedia.linkedin = this.currentUser.linkedin
          socialmedia.twitch = this.currentUser.twitch
          socialmedia.youtube = this.currentUser.youtube
          socialmedia.instagram = this.currentUser.instagram
          socialmedia.tiktok = this.currentUser.tiktok
          socialmedia.other = this.currentUser.othersocialmedia
          socialmedia.website = this.currentUser.website
          socialmedia.bsky = this.currentUser.bsky
          socialmedia.fediverse = this.currentUser.fediverse
        } else if (fieldName=='contact_email') {
          text = this.currentUser.contact_email.email
        } else { // text answer
          text = this.currentUser[fieldName]
        }
        // bonus case for can_ x things
        if (fieldName.startsWith('can_')) {
          text = this.currentUser[`${fieldName}_exceptions`]
        }
      }
      // if there's not one, create a new one
      // console.debug("getting a new response")
      this.newResponse({relationships, answers, text, socialmedia});
      return utils.deepCopy(this.getExistingResponse(relationships))
    },
    saveResponse(response){
      // saving the response only
      if (!this.previewMode) {
        // only save if not in preview mode and if the response was already saved!
        return this.mergeRecords(response); // this version only saves locally
        //return this.jvPost(response); // this version saves to the server
      }
    }
  }
}

export default responseMixin;
