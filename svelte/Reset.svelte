<script>
	import { count } from './store.js'
	const Reset = () => count.reset();
</script>
<button on:click={Reset}>reset!</button>