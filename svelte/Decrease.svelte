<script>
	import { count } from './store.js'	
	const Decrease = () => count.decrease();
</script>
<button on:click={Decrease}>-</button>