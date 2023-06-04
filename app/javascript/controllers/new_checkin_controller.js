import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  showMoraleComment(event) {
    event.preventDefault();
    this.moraleCommentTarget.value = "";
    this.moraleCommentTarget.classList.toggle("d-none");
  }
}
