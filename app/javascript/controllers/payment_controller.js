import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = ["selection", "additionalFields"];

  initialize() {
    this.showAdditionalFields();
  }

  showAdditionalFields() {
    // Get the selected option element
    const selectedOption =
      this.selectionTarget.options[this.selectionTarget.selectedIndex];

    // Get the text of the selected payment type (e.g., "Check", "Credit card", etc.)
    let paymentTypeName = selectedOption ? selectedOption.text : "";

    for (let fields of this.additionalFieldsTargets) {
      // Compare with the data-type attribute which should contain the payment type name
      fields.disabled = fields.hidden = fields.dataset.type != paymentTypeName;
    }
  }
}
