import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['moraleComment']

  showMoraleComment(event) {
    event.preventDefault();

    this.moraleCommentTarget.value = "";
    this.moraleCommentTarget.classList.toggle("d-none");
  }

  appendHtml(event) {
    event.preventDefault();

    const random_index = Date.now();
    const model = event.currentTarget.dataset.model;
    const html = decodeURIComponent(event.currentTarget.dataset.html).replace(new RegExp('_' + model + '_id_placeholder_', 'g'), random_index);
    event.currentTarget.previousElementSibling.insertAdjacentHTML('beforeend', html);
  }

  closeParent(event) {
    event.preventDefault();
    const wrapper = event.currentTarget.closest(event.currentTarget.dataset.wrapperSelector)

    if (wrapper.classList.contains('persisted')) {
      wrapper.parentElement.querySelector('[name$="[_destroy]"]').value = '1';
    }

    wrapper.remove();
  }
}
