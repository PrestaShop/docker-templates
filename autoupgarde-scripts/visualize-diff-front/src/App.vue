<template>
  <header>
    <h1 class="puik-h1">
      Visualize Difference
    </h1>
  </header>

  <main class="puik">
    <puik-card>
      <span class="puik-h3">Configuration</span>
      <div class="filter-container">
        <div>
          <puik-label for="select1">First file</puik-label>
          <puik-select id="select1" v-model="select1" :options="select1options">
          </puik-select>
        </div>
        <div>
          <puik-label for="select2">Second file</puik-label>
          <puik-select id="select2" v-model="select2" :options="select2options">
          </puik-select>
        </div>
        <puik-checkbox v-model="sideBySide" label="Side by side mode" />
        <puik-button
            left-icon="rocket_launch"
            @click="getDiff"
        >
          Get diff
        </puik-button>
        <puik-button
            left-icon="refresh"
            variant="secondary"
            @click="requestSqlDumpList"
        >
          Reload files
        </puik-button>
      </div>
    </puik-card>

    <div>
      <CodeDiff
          :oldString="file1"
          :newString="file2"
          :filename="select1"
          :newFilename="select2"
          language="sql"
          :outputFormat="sideBySide ? 'side-by-side' : 'line-by-line'"
      />
    </div>
  </main>
</template>

<script setup lang="ts">
import {onBeforeMount, ref, computed} from 'vue';
import type { Ref } from 'vue';
import axios from 'axios';

import { CodeDiff } from 'v-code-diff'

const select1: Ref<string> = ref('');
const file1: Ref<string> = ref('');
const select1options = computed(() => sqlDumpFiles.value);

const select2: Ref<string> = ref('');
const file2: Ref<string> = ref('');
const select2options = computed(() => sqlDumpFiles.value.filter((file : string) => file !== select1.value));

const sideBySide: Ref<boolean> = ref(false);

const sqlDumpFiles: Ref<string[]> = ref([]);

const serverUrl = 'http://localhost:3000';

const requestSqlDumpList = async() => {
  try {
    const response = await axios.get(serverUrl + '/sql_dumps');
    sqlDumpFiles.value = response.data;
  } catch (error) {
    console.error('Erreur lors de la récupération de la liste des fichiers :', error);
  }
}

const requestSqlDumpContent = async(fileName: string) => {
  try {
    const response = await axios.get(serverUrl + `/sql_dump_content?fileName=${fileName}`);
    return response.data; // Renvoyer le contenu du fichier SQL récupéré
  } catch (error) {
    console.error('Erreur lors de la récupération du contenu du fichier SQL :', error);
    throw error; // Propager l'erreur pour la gérer à l'endroit où la méthode est appelée
  }
}

const getDiff = async() => {
  if (!select1.value || !select2.value) {
    console.error('One file selection is missing');
  }
  if (select1.value) {
    const response1 = await requestSqlDumpContent(select1.value);
    if (response1) {
      file1.value = response1
    }
  }

  if (select2.value) {
    const response2 = await requestSqlDumpContent(select2.value);
    if (response2) {
      file2.value = response2
    }
  }
}

onBeforeMount(async () => {
  await requestSqlDumpList();
})
</script>
