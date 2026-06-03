#let footer_name_state = state("footer-name", "")

#let set_footer_name(name) = footer_name_state.update(name)

#let get_footer_name() = context {
  footer_name_state.get()
}