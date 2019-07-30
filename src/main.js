import { Elm } from './elm/Main.elm'
import VirtualAudioGraph from './js/virtual-audio'

const context = new (AudioContext || webkit.AudioContext)()

// These days, an audio context starts in a suspended state and must be 
// explicitly resumed after some user interaction event. This is a catch-all
// solution. Ideally you'll create a port and do this inside the elm application
// whenever it is most appropriate.
window.onclick = () => {
  if (context.state === 'suspended') context.resume()
}

const audio = new VirtualAudioGraph(context)
const app = Elm.Main.init({
  node: document.querySelector('#app'),
  flags: context
})

app.ports.updateAudio.subscribe(graph => {
  audio.update(graph)
})
