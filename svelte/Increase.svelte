<script>
	import { count } from './store.js'
	const Increase = () => count.increase();
</script>
<button on:click={Increase}>+</button>