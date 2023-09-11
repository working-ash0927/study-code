<script>
	import { count } from './store.js'
	import Increase from './Increase.svelte'
	import Decrease from './Decrease.svelte'
	import Reset from './Reset.svelte'
	import Result from './Result.svelte'
	$: console.log($count) // 변경된 변수값을 추적
</script>

<Increase />
<Decrease />
<Reset />
<Result />
