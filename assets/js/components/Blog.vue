<template>
    <div class="blog">
        <!-- <h1>Blog</h1> -->
    </div>
</template>

<script lang="ts">

import { Prop, Component } from "vue-property-decorator"

// type ComplexObjectInterface = {
//   testProp: string
//   modelName: number
// }

@Component
export default Blog extends Component {
  name: string = 'Blog'

  // @Prop({
  //   type: Object
  // })
  // propExample: ComplexObjectInterface

  // dataExample: string = "This Property Will Be Data"
  //
  // get computedExample() {
  //   return this.dataExample + this.propExample.testProp + "Computed Property Example";
  // }
  //
  // methodExample() {
  //   this.dataExample = "This is being done in a method"
  // }
}

</script>

<style scoped>
  .blog {
      color: red;
  }
</style>
